import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app_lablap/laboratorium.dart';
import 'package:mobile_app_lablap/report.dart';
import 'package:mobile_app_lablap/service/data_service.dart';
import 'package:mobile_app_lablap/data_barang.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LapLab',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nama = new TextEditingController();
  TextEditingController nim = new TextEditingController();
  TextEditingController email = new TextEditingController();

  @override
  void initState() {
    super.initState();
    resetData();
  }

  resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('barang');
    await prefs.remove('pelapor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
              child: Image.asset('logo.png'),
            ),
            SizedBox(height: 50.0),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: nama,
                      decoration: InputDecoration(hintText: "Masukan Nama"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: nim,
                      decoration: InputDecoration(
                          hintText: "Masukan Nomor Induk Mahasiswa"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(hintText: "Masukan Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // log('Nama:' + nama.text);

                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          var insertPelapor = await DataService()
                              .setUser(nama.text, nim.text, email.text);

                          if (insertPelapor) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return Laboratorium();
                              }),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.blueGrey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
