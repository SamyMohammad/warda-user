// To parse this JSON data, do
//
//     final questionsModel = questionsModelFromJson(jsonString);

import 'dart:convert';

QuestionsModel questionsModelFromJson(String str) =>
    QuestionsModel.fromJson(json.decode(str));

String questionsModelToJson(QuestionsModel data) => json.encode(data.toJson());

class QuestionsModel {
  final List<Question> questions;

  QuestionsModel({
    required this.questions,
  });

  factory QuestionsModel.fromJson(Map<String, dynamic> json) => QuestionsModel(
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  final int id;
  final String q;
  final String placeholder;
  final String type;
  final List<Choice> choices;

  Question({
    required this.id,
    required this.q,
    required this.placeholder,
    required this.type,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        q: json["q"],
        placeholder: json["placeholder"],
        type: json["type"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "q": q,
        "placeholder": placeholder,
        "type": type,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };
}

class Choice {
  final String name;

  Choice({
    required this.name,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
