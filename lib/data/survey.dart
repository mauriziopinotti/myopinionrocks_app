import '../models/survey.dart';

class SurveySubmissionRequest {
  Survey survey;

  SurveySubmissionRequest(this.survey);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['surveyId'] = survey.id;
    data['surveyAnswers'] = survey.currentSubmission
        .map((question, answer) => MapEntry(question.id.toString(), answer.id));
    return data;
  }

  @override
  String toString() {
    return 'SurveySubmissionRequest{survey: $survey, submission: ${survey.currentSubmission}';
  }
}

class SurveySubmissionResponse {
  late int id;
  // late DateTime dateTime;

  SurveySubmissionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // dateTime = DateTime.parse(json['dateTime']);
  }
}
