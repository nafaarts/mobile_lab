// To parse this JSON data, do
//
//     final laporan = laporanFromJson(jsonString);

import 'dart:convert';

Laporan laporanFromJson(String str) => Laporan.fromJson(json.decode(str));

String laporanToJson(Laporan data) => json.encode(data.toJson());

class Laporan {
  Laporan({
    this.pelapor,
    this.barang,
  });

  Pelapor? pelapor;
  List<BarangLaporan>? barang;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        pelapor:
            json["pelapor"] == null ? null : Pelapor.fromJson(json["pelapor"]),
        barang: json["barang"] == null
            ? null
            : List<BarangLaporan>.from(
                json["barang"].map((x) => BarangLaporan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pelapor": pelapor == null ? null : pelapor!.toJson(),
        "barang": barang == null
            ? null
            : List<dynamic>.from(barang!.map((x) => x.toJson())),
      };
}

class BarangLaporan {
  BarangLaporan(
      {this.barangId,
      this.kondisi,
      this.keterangan,
      this.nama_barang,
      this.laboratorium,
      this.nomor_barang});

  String? barangId;
  String? kondisi;
  String? keterangan;
  String? nama_barang;
  String? laboratorium;
  String? nomor_barang;

  factory BarangLaporan.fromJson(Map<String, dynamic> json) => BarangLaporan(
        barangId: json["barang_id"] == null ? null : json["barang_id"],
        kondisi: json["kondisi"] == null ? null : json["kondisi"],
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
        nama_barang: json["nama_barang"] == null ? null : json["nama_barang"],
        laboratorium:
            json["laboratorium"] == null ? null : json["laboratorium"],
        nomor_barang:
            json["nomor_barang"] == null ? null : json["nomor_barang"],
      );

  Map<String, dynamic> toJson() => {
        "barang_id": barangId == null ? null : barangId,
        "kondisi": kondisi == null ? null : kondisi,
        "keterangan": keterangan == null ? null : keterangan,
        "nama_barang": nama_barang == null ? null : nama_barang,
        "laboratorium": laboratorium == null ? null : laboratorium,
        "nomor_barang": nomor_barang == null ? null : nomor_barang,
      };

  static Map<String, dynamic> toMap(BarangLaporan barang) => {
        'barang_id': barang.barangId,
        'kondisi': barang.kondisi,
        'keterangan': barang.keterangan,
        'nama_barang': barang.nama_barang,
        'laboratorium': barang.laboratorium,
        'nomor_barang': barang.nomor_barang,
      };

  static String encode(List<BarangLaporan> barangs) => json.encode(
        barangs
            .map<Map<String, dynamic>>((barang) => BarangLaporan.toMap(barang))
            .toList(),
      );

  static List<BarangLaporan> decode(String barangs) =>
      (json.decode(barangs) as List<dynamic>)
          .map<BarangLaporan>((item) => BarangLaporan.fromJson(item))
          .toList();
}

class Pelapor {
  Pelapor({
    this.nama,
    this.nim,
    this.email,
  });

  String? nama;
  String? nim;
  String? email;

  factory Pelapor.fromJson(Map<String, dynamic> json) => Pelapor(
        nama: json["nama"] == null ? null : json["nama"],
        nim: json["nim"] == null ? null : json["nim"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama == null ? null : nama,
        "nim": nim == null ? null : nim,
        "email": email == null ? null : email,
      };

  static Map<String, dynamic> toMap(Pelapor pelapor) => {
        'nama': pelapor.nama,
        'nim': pelapor.nim,
        'email': pelapor.email,
      };

  static String encode(List<Pelapor> pelapor) => json.encode(
        pelapor
            .map<Map<String, dynamic>>((pelapor) => Pelapor.toMap(pelapor))
            .toList()
            .first,
      );
}
