// To parse this JSON data, do
//
//     final sizessModel = sizessModelFromJson(jsonString);

import 'dart:convert';

SizessModel sizessModelFromJson(String str) =>
    SizessModel.fromJson(json.decode(str));

String sizessModelToJson(SizessModel data) => json.encode(data.toJson());

class SizessModel {
  final String status;
  final List<SizeItem> size;

  SizessModel({
    required this.status,
    required this.size,
  });

  factory SizessModel.fromJson(Map<String, dynamic> json) => SizessModel(
        status: json["status"],
        size:
            List<SizeItem>.from(json["data"].map((x) => SizeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(size.map((x) => x.toJson())),
      };
}

class SizeItem {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  SizeItem({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SizeItem.fromJson(Map<String, dynamic> json) => SizeItem(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
