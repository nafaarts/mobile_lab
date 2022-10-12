import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app_lablap/laboratorium.dart';
import 'package:mobile_app_lablap/model/laporan.dart';
import 'package:mobile_app_lablap/report.dart';
import 'package:mobile_app_lablap/report_count.dart';
import 'package:mobile_app_lablap/service/data_service.dart';

const List<String> list = <String>['baik', 'rusak', 'hilang'];

class DetailBarangScreen extends StatefulWidget {
  const DetailBarangScreen(
      {super.key,
      required this.nomor_ruangan,
      required this.id,
      required this.nama_barang,
      required this.nomor_barang});

  final String nomor_ruangan;
  final String id; // id barang
  final String nama_barang;
  final String nomor_barang;

  @override
  State<DetailBarangScreen> createState() => _DetailBarangScreenState();
}

class _DetailBarangScreenState extends State<DetailBarangScreen> {
  String dropdownValue = list.first;
  final _formKey = GlobalKey<FormState>();

  TextEditingController keterangan = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laboratorium ${widget.nomor_ruangan}'),
        centerTitle: true,
        // actions: [ReportCount()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  '${widget.nama_barang} - ${widget.nomor_barang}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 18.0),
              underline: Container(
                height: 0.7,
                color: Colors.blueGrey,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              controller: keterangan,
              // The validator receives the text that the user has entered.
              decoration: InputDecoration(hintText: "Keterangan"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  var insertBarang = await DataService().addBarangLaporan(
                      widget.id,
                      widget.nama_barang,
                      dropdownValue,
                      keterangan.text,
                      widget.nomor_ruangan,
                      widget.nomor_barang);

                  if (insertBarang) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Laboratorium();
                      // return Report();
                    }));
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
