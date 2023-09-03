// To parse this JSON data, do
//
//     final flowerTypesModel = flowerTypesModelFromJson(jsonString);

import 'dart:convert';

FlowerTypesModel flowerTypesModelFromJson(String str) =>
    FlowerTypesModel.fromJson(json.decode(str));

String flowerTypesModelToJson(FlowerTypesModel data) =>
    json.encode(data.toJson());

class FlowerTypesModel {
  final String status;
  final List<FlowerType> data;

  FlowerTypesModel({
    required this.status,
    required this.data,
  });

  factory FlowerTypesModel.fromJson(Map<String, dynamic> json) =>
      FlowerTypesModel(
        status: json["status"],
        data: List<FlowerType>.from(
            json["data"].map((x) => FlowerType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FlowerType {
  final int id;
  final String type;

  FlowerType({
    required this.id,
    required this.type,
  });

  factory FlowerType.fromJson(Map<String, dynamic> json) => FlowerType(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}
