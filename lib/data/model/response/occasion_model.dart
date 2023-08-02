class OccasionsModel {
  final String status;
  final List<Occasion> occasion;

  OccasionsModel({
    required this.status,
    required this.occasion,
  });

  factory OccasionsModel.fromJson(Map<String, dynamic> json) => OccasionsModel(
        status: json["status"],
        occasion:
            List<Occasion>.from(json["data"].map((x) => Occasion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(occasion.map((x) => x.toJson())),
      };
}

class Occasion {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Occasion({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Occasion.fromJson(Map<String, dynamic> json) => Occasion(
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
