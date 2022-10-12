import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/lab_detail.dart';
import 'package:mobile_app_lablap/laboratorium.dart';
import 'package:mobile_app_lablap/model/laporan.dart';
import 'package:mobile_app_lablap/service/data_service.dart';
import 'package:mobile_app_lablap/service/remote_service.dart';
import 'package:mobile_app_lablap/success.dart';

import 'package:http/http.dart' as http;

class Report extends StatefulWidget {
  const Report({super.key, required this.nomor_ruangan, required this.image});
  final String nomor_ruangan;
  final String image;
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<BarangLaporan>? barangs;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    barangs = await DataService().getBarangLaporan();
    if (barangs != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Anda'),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return LabDetail(
                nomor_ruangan: widget.nomor_ruangan,
                image: widget.image,
              );
            }));
          },
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.delete),
            ),
            onTap: () async {
              var deleted = await DataService().resetBarang();
              if (deleted) {
                setState(() {
                  barangs = [];
                });
              }
              // if (deleted) {
              //   Navigator.of(context)
              //       .push(MaterialPageRoute(builder: (BuildContext context) {
              //     return Report();
              //   }));
              // }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memproses Data')),
          );

          String pelaporString = await DataService().getUser();
          Pelapor pelapor = Pelapor.fromJson(jsonDecode(pelaporString));
          List<BarangLaporan> barang = await DataService().getBarangLaporan();
          Laporan laporan = Laporan(barang: barang, pelapor: pelapor);

          var body = json.encode(laporan);
          print(body);

          var client = http.Client();
          var uri = Uri.parse('https://aida.nafaarts.com/api/laporan');
          var response = await client.post(
            uri,
            body: body,
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) {
              return Success();
            }), (route) => false);
          }
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.send),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: barangs?.length ?? 0,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${barangs![index].nama_barang}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${barangs![index].laboratorium}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 5),
                            SizedBox(height: 5),
                            Text(
                                'nomor barang : ${barangs![index].nomor_barang}'),
                            SizedBox(height: 5),
                            Text('kondisi : ${barangs![index].kondisi}'),
                            SizedBox(height: 5),
                            Text('keterangan : ${barangs![index].keterangan}'),
                          ],
                        ),
                      ),
                    ));
              }),
        ),
      ),
    );
  }
}
