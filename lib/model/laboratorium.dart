// To parse this JSON data, do
//
//     final laboratoriumModel = laboratoriumModelFromJson(jsonString);

import 'dart:convert';

List<LaboratoriumModel> laboratoriumModelFromJson(String str) =>
    List<LaboratoriumModel>.from(
        json.decode(str).map((x) => LaboratoriumModel.fromJson(x)));

String laboratoriumModelToJson(List<LaboratoriumModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LaboratoriumModel {
  LaboratoriumModel({
    this.nomor,
    this.image,
  });

  String? nomor;
  String? image;

  factory LaboratoriumModel.fromJson(Map<String, dynamic> json) =>
      LaboratoriumModel(
        nomor: json["nomor"] == null ? null : json["nomor"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor == null ? null : nomor,
        "image": image == null ? null : image,
      };
}
