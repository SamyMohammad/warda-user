// To parse this JSON data, do
//
//     final flowerColorsModel = flowerColorsModelFromJson(jsonString);

import 'dart:convert';

FlowerColorsModel flowerColorsModelFromJson(String str) =>
    FlowerColorsModel.fromJson(json.decode(str));

String flowerColorsModelToJson(FlowerColorsModel data) =>
    json.encode(data.toJson());

class FlowerColorsModel {
  final String status;
  final List<FlowerColor> data;

  FlowerColorsModel({
    required this.status,
    required this.data,
  });

  factory FlowerColorsModel.fromJson(Map<String, dynamic> json) =>
      FlowerColorsModel(
        status: json["status"],
        data: List<FlowerColor>.from(
            json["data"].map((x) => FlowerColor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FlowerColor {
  final int id;
  final String color;

  FlowerColor({
    required this.id,
    required this.color,
  });

  factory FlowerColor.fromJson(Map<String, dynamic> json) => FlowerColor(
        id: json["id"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
      };
}
