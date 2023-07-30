import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/models/survey.dart';
import 'package:myopinionrocks_app/widgets/scaffold.dart';

class SurveyCompletedScreen extends StatelessWidget {
  final Survey survey;

  const SurveyCompletedScreen(this.survey, {super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(child: Center(child: Text("Survey Completed: $survey")));
  }
}
