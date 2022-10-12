import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/data_barang.dart';

import 'package:mobile_app_lablap/model/barang.dart';
import 'package:mobile_app_lablap/model/laporan.dart';
import 'package:mobile_app_lablap/report_count.dart';
import 'package:mobile_app_lablap/service/remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabDetail extends StatefulWidget {
  const LabDetail(
      {super.key, required this.nomor_ruangan, required this.image});

  final String nomor_ruangan;
  final String image;

  @override
  State<LabDetail> createState() => _LabDetailState();
}

class _LabDetailState extends State<LabDetail> {
  List<BarangModel>? barang;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    barang = await RemoteService().getBarang(widget.nomor_ruangan);
    if (barang != null) {
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
      body: SingleChildScrollView(
        // physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Image.network(widget.image),
            SizedBox(height: 20.0),
            Visibility(
              visible: isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                // barang
                children: List.generate(barang?.length ?? 0, (index) {
                  return Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return DataBarang(
                                  nomor_ruangan: widget.nomor_ruangan,
                                  id: '${barang![index].id}',
                                  nama_barang: '${barang![index].nama}',
                                  image: widget.image);
                            }),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          color: Colors.blueGrey,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 25.0),
                            child: Center(
                              child: Text(
                                '${barang![index].nama}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
