import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:mobile_app_lablap/model/detail_barang.dart';
import 'package:mobile_app_lablap/report.dart';
import 'package:mobile_app_lablap/report_count.dart';
import 'package:mobile_app_lablap/service/data_service.dart';
import 'package:mobile_app_lablap/service/remote_service.dart';

List<DetailBarang>? listbarang;
var isEdited = false;

class DataBarang extends StatefulWidget {
  const DataBarang(
      {super.key,
      required this.nomor_ruangan,
      required this.image,
      required this.id,
      required this.nama_barang});

  final String nomor_ruangan;
  final String id;
  final String nama_barang;
  final String image;

  @override
  State<DataBarang> createState() => _DataBarangState();
}

class _DataBarangState extends State<DataBarang> {
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    listbarang =
        await RemoteService().getListBarang(widget.nomor_ruangan, widget.id);
    if (listbarang != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laboratorium ${widget.nomor_ruangan}"),
        centerTitle: true,
        actions: [
          ReportCount(
            nomor_ruangan: widget.nomor_ruangan,
            image: widget.image,
          )
        ],
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List<Widget>.generate(
                listbarang?.length ?? 0,
                (index) => ListBarang(
                    index: index,
                    data: listbarang![index],
                    nama_barang: widget.nama_barang),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEdited) {
            for (var e in listbarang!) {
              if (e.kondisi != null || e.keterangan != null) {
                await DataService().addBarangLaporan(
                    e.id.toString(),
                    widget.nama_barang,
                    e.kondisi ?? '',
                    e.keterangan ?? '',
                    widget.nomor_ruangan,
                    e.nomorBarang ?? '');
              }
            }
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Report(
                  nomor_ruangan: widget.nomor_ruangan,
                  image: widget.nomor_ruangan);
            }));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tidak ada perubahan apapun!'),
              ),
            );
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class ListBarang extends StatefulWidget {
  DetailBarang? data;
  String? nama_barang;
  final int index;

  ListBarang({required this.index, this.data, this.nama_barang});

  @override
  _ListBarangState createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  List<String> data = ['baik', 'rusak', 'hilang'];
  TextEditingController keterangan = new TextEditingController();
  String groupValue = '';

  @override
  void initState() {
    super.initState();
    groupValue = widget.data!.kondisi ?? 'baik';
    keterangan.text = widget.data!.keterangan ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.grey.shade300,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.nama_barang ?? '-',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.data!.nomorBarang ?? '-',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: keterangan,
              // The validator receives the text that the user has entered.
              decoration: InputDecoration(hintText: "Keterangan"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (String? value) {
                if (value != null) {
                  listbarang![widget.index].keterangan = value;
                  isEdited = true;
                }
              },
            ),
          ),
          Row(
              children: List<Widget>.generate(
            data.length,
            (int i) => Expanded(
                child: Row(
              children: [
                Radio<String>(
                  value: data[i],
                  groupValue: groupValue,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        groupValue = value;
                      });

                      listbarang![widget.index].kondisi = value;
                      isEdited = true;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text('mengubah ke ${value}'),
                        ),
                      );
                    }
                  },
                ),
                Text(data[i])
              ],
            )),
          )),
        ],
      ),
    );
  }
}
