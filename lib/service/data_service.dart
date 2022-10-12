import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_lablap/model/laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  Future<bool> setUser(String name, String nim, String email) async {
    final prefs = await SharedPreferences.getInstance();

    List<Pelapor> pelapor = [Pelapor(nama: name, nim: nim, email: email)];

    String? pelaporString = Pelapor.encode(pelapor);

    log('Pelapor: ' + pelaporString);

    return await prefs.setString('pelapor', pelaporString);
  }

  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var data = await prefs.getString('pelapor');
    return data.toString();
  }

  Future<List<BarangLaporan>> getBarangLaporan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('user').toString();
    final String? barangsString = await prefs.getString('barang');
    final List<BarangLaporan> barangs;
    if (barangsString != null) {
      barangs = BarangLaporan.decode(barangsString!);
    } else {
      barangs = [];
    }
    return barangs;
  }

  Future<bool> addBarangLaporan(String id, String nama_barang, String kondisi,
      String keterangan, String laboratorium, String nomor_barang) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? barangsString = await prefs.getString('barang');

    final List<BarangLaporan> barangs =
        barangsString == null ? [] : BarangLaporan.decode(barangsString!);

    var check = barangs.indexWhere((barang) => (barang.barangId!.contains(id)));

    // log('check : ' + check.toString());

    if (check == -1) {
      barangs.add(BarangLaporan(
          barangId: id,
          nama_barang: nama_barang,
          kondisi: kondisi,
          keterangan: keterangan,
          laboratorium: laboratorium,
          nomor_barang: nomor_barang));
    } else {
      barangs[check] = BarangLaporan(
          barangId: id,
          nama_barang: nama_barang,
          kondisi: kondisi,
          keterangan: keterangan,
          laboratorium: laboratorium,
          nomor_barang: nomor_barang);
    }

    // Encode and store data in SharedPreferences
    final String encodedData = BarangLaporan.encode(barangs);
    var result = await prefs.setString('barang', encodedData);

    // String? baru = await prefs.getString('barang');
    // log('current barangs : ' + baru.toString());
    return result;
  }

  Future<bool> resetBarang() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('barang');
  }
}
