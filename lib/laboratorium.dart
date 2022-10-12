import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/lab_detail.dart';
import 'package:mobile_app_lablap/model/laboratorium.dart';
import 'package:mobile_app_lablap/report.dart';
import 'package:mobile_app_lablap/report_count.dart';
import 'package:mobile_app_lablap/service/data_service.dart';
import 'package:mobile_app_lablap/service/remote_service.dart';

class Laboratorium extends StatefulWidget {
  const Laboratorium({super.key});

  @override
  State<Laboratorium> createState() => _LaboratoriumState();
}

class _LaboratoriumState extends State<Laboratorium> {
  List<LaboratoriumModel>? laboratorium;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    laboratorium = await RemoteService().getLaboratorium();
    if (laboratorium != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Laboratorium'),
          centerTitle: true,
          // actions: [ReportCount()],
        ),
        body: Column(
          children: [
            SizedBox(height: 20.0),
            Visibility(
              visible: isLoaded,
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 3,
                // mainAxisSpacing: 0,
                childAspectRatio: 3 / 2,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                // Generate 100 widgets that display their index in the List.
                children: List.generate(laboratorium?.length ?? 0, (index) {
                  return Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return LabDetail(
                                  nomor_ruangan:
                                      '${laboratorium![index].nomor}',
                                  image: '${laboratorium![index].image}');
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
                                'Lab ${laboratorium![index].nomor}',
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
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}
