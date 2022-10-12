import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/model/laporan.dart';
import 'package:mobile_app_lablap/report.dart';
import 'package:mobile_app_lablap/service/data_service.dart';

class ReportCount extends StatefulWidget {
  const ReportCount({super.key, required this.nomor_ruangan, required this.image});

  final String nomor_ruangan;
  final String image;

  @override
  State<ReportCount> createState() => _ReportCountState();
}

class _ReportCountState extends State<ReportCount> {
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
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Report(
                  nomor_ruangan: widget.nomor_ruangan, image: widget.image);
            }));
          },
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: Visibility(
                  visible: isLoaded,
                  replacement: Text('-'),
                  child: Text(
                    '${barangs?.length ?? 0}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Icon(Icons.report_problem),
            ],
          )),
    );
  }
}
