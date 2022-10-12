import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mobile_app_lablap/model/barang.dart';
import 'package:mobile_app_lablap/model/detail_barang.dart';
import 'package:mobile_app_lablap/model/laboratorium.dart';
import 'package:mobile_app_lablap/model/laporan.dart';

class RemoteService {
  Future<List<LaboratoriumModel>?> getLaboratorium() async {
    var client = http.Client();
    var uri = Uri.parse('https://aida.nafaarts.com/api/laboratorium');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      // log('from json: ' + json);
      return laboratoriumModelFromJson(json);
    }

    return null;
  }

  Future<List<BarangModel>?> getBarang(String nomor_ruangan) async {
    var client = http.Client();
    var uri = Uri.parse('https://aida.nafaarts.com/api/laboratorium/' +
        nomor_ruangan +
        '/barang');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      // log('from json: ' + json);
      return barangFromJson(json);
    }

    return null;
  }

  Future<List<DetailBarang>?> getListBarang(
      String nomor_ruangan, String id) async {
    var client = http.Client();
    var uri = Uri.parse('https://aida.nafaarts.com/api/laboratorium/' +
        nomor_ruangan +
        '/barang/' +
        id);
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      // log('from json: ' + json);
      return detailBarangFromJson(json);
    }

    return null;
  }

  // Future<bool> kirimLaporan(<String, dynamic> body) async {
  //   var client = http.Client();
  //   var uri = Uri.parse('https://aida.nafaarts.com/api/laporan');
  //   var response = await client.post(uri, body: body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return true;
  //   }
  //   return false;
  // }
}
