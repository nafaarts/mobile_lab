// To parse this JSON data, do
//
//     final barang = barangFromJson(jsonString);

import 'dart:convert';

List<BarangModel> barangFromJson(String str) => List<BarangModel>.from(
    json.decode(str).map((x) => BarangModel.fromJson(x)));

String barangToJson(List<BarangModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarangModel {
  BarangModel({
    this.id,
    this.nama,
  });

  String? id;
  String? nama;

  factory BarangModel.fromJson(Map<String, dynamic> json) => BarangModel(
        id: json["id"] == null ? null : json["id"],
        nama: json["nama"] == null ? null : json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nama": nama == null ? null : nama,
      };
}
