// To parse this JSON data, do
//
//     final detailBarang = detailBarangFromJson(jsonString);

import 'dart:convert';

List<DetailBarang> detailBarangFromJson(String str) => List<DetailBarang>.from(
    json.decode(str).map((x) => DetailBarang.fromJson(x)));

String detailBarangToJson(List<DetailBarang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailBarang {
  DetailBarang({
    this.id,
    this.laboratoriumId,
    this.jenisBarangId,
    this.nomorBarang,
    this.kondisi,
    this.keterangan,
  });

  int? id;
  String? laboratoriumId;
  String? jenisBarangId;
  String? nomorBarang;
  String? kondisi;
  String? keterangan;

  factory DetailBarang.fromJson(Map<String, dynamic> json) => DetailBarang(
        id: json["id"] == null ? null : json["id"],
        laboratoriumId:
            json["laboratorium_id"] == null ? null : json["laboratorium_id"],
        jenisBarangId:
            json["jenis_barang_id"] == null ? null : json["jenis_barang_id"],
        nomorBarang: json["nomor_barang"] == null ? null : json["nomor_barang"],
        kondisi: json["kondisi"] == null ? null : json["kondisi"],
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "laboratorium_id": laboratoriumId == null ? null : laboratoriumId,
        "jenis_barang_id": jenisBarangId == null ? null : jenisBarangId,
        "nomor_barang": nomorBarang == null ? null : nomorBarang,
        "kondisi": kondisi == null ? null : kondisi,
        "keterangan": keterangan == null ? null : keterangan,
      };
}
