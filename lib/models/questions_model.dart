
/// GPT questions model
class QuestionsModel {
  final List<String> questions;

  QuestionsModel({
    required this.questions,
  });

  QuestionsModel copyWith({
    List<String>? questions,
  }) {
    return QuestionsModel(
      questions: questions ?? this.questions,
    );
  }

  factory QuestionsModel.fromJson(Map<String, dynamic> json) {
    return QuestionsModel(
      questions: List<String>.from(json['questions'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': List<dynamic>.from(questions.map((x) => x)),
    };
  }
}