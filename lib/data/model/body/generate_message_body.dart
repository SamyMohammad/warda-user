class GenerateMessageBody {
  final List<QuestionQnswerBody> answers;

  GenerateMessageBody({required this.answers});
}

class QuestionQnswerBody {
  final String q;
  final String a;

  QuestionQnswerBody({required this.q, required this.a});

  Map<String, String> toJson() {
    return {
      "q": q,
      "a": a,
    };
  }
}
