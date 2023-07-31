import 'package:collection/collection.dart';

import '../extensions.dart';

/// App model for surveys.
class Survey {
  late int id;
  late String title;
  late List<SurveyQuestion> questions = [];
  late Map<SurveyQuestion, Map<SurveyAnswer, int>> prevSubmissionsCount = {};

  // App-only fields
  Map<SurveyQuestion, SurveyAnswer> currentSubmission = {};

  /// Returns true if all questions have been answered.
  bool get isComplete =>
      questions.firstWhereOrNull((q) => !currentSubmission.containsKey(q)) ==
      null;

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = (json['title'] as String).unescape;
    json['surveyQuestions']
        ?.forEach((v) => questions.add(SurveyQuestion.fromJson(v)));

    // Parse previousSubmissionsCount
    (json['previousSubmissionsCount'] as Map).forEach((k, v) {
      final question = questions.firstWhere((q) => q.id == int.parse(k));
      prevSubmissionsCount.putIfAbsent(question, () => {});
      (v as Map).forEach((k, v) {
        final answer = question.answers.firstWhere((a) => a.id == int.parse(k));
        prevSubmissionsCount[question]!.putIfAbsent(answer, () => v);
      });
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Survey && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Survey{id: $id, title: $title, questions: ${questions.length} questions';
  }
}

class SurveyQuestion {
  late int id;
  late String title;
  late List<SurveyAnswer> answers = [];

  SurveyQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = (json['title'] as String).unescape;
    json['surveyAnswers']
        ?.forEach((v) => answers.add(SurveyAnswer.fromJson(v)));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyQuestion &&
          runtimeType == other.runtimeType &&
          answers == other.answers;

  @override
  int get hashCode => answers.hashCode;

  @override
  String toString() {
    return 'SurveyQuestion{id: $id, title: $title, answers: ${answers.length} answers';
  }
}

class SurveyAnswer {
  late int id;
  late String title;

  SurveyAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = (json['title'] as String).unescape;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyAnswer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'SurveyAnswer{id: $id, title: $title}';
  }
}
