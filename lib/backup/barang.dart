import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/backup/barang_detail.dart';
import 'package:mobile_app_lablap/model/detail_barang.dart';
import 'package:mobile_app_lablap/report_count.dart';
import 'package:mobile_app_lablap/service/remote_service.dart';

class ListBarang extends StatefulWidget {
  const ListBarang(
      {super.key,
      required this.nomor_ruangan,
      required this.id,
      required this.nama_barang});

  final String nomor_ruangan;
  final String id;
  final String nama_barang;

  @override
  State<ListBarang> createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  List<DetailBarang>? listbarang;
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
        // actions: [ReportCount()],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.nama_barang,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Visibility(
              visible: isLoaded,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listbarang?.length ?? 0,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return DetailBarangScreen(
                                  nomor_ruangan: widget.nomor_ruangan,
                                  nama_barang: widget.nama_barang,
                                  nomor_barang:
                                      listbarang![index].nomorBarang.toString(),
                                  id: listbarang![index].id.toString());
                            }));
                          },
                          leading: Text(
                            '${listbarang![index].nomorBarang}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Center(
                            child: Text("${listbarang![index].kondisi}",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                          ),
                          tileColor: Colors.grey.shade300,
                          trailing: Icon(Icons.more_vert)),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
