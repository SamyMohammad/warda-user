// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  final String status;
  final List<FaqItem> faqItem;

  FaqModel({
    required this.status,
    required this.faqItem,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        status: json["status"],
        faqItem:
            List<FaqItem>.from(json["data"].map((x) => FaqItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(faqItem.map((x) => x.toJson())),
      };
}

class FaqItem {
  final int id;
  final String question;
  final String answer;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
      };
}
