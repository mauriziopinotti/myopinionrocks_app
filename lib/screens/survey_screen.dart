import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/data/rest_client.dart';
import 'package:myopinionrocks_app/generated/locale_keys.g.dart';

import '../globals.dart';
import '../models/survey.dart';
import '../theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/loader.dart';
import '../widgets/scaffold.dart';
import 'survey_completed_screen.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        child: Center(
            child: FutureBuilder<Survey>(
                future: RestClient().getSurvey(),
                builder: (_, AsyncSnapshot<Survey> snapshot) =>
                    snapshot.connectionState != ConnectionState.done
                        ? MyLoader(LocaleKeys.msg_loading_survey.tr())
                        : WillPopScope(
                            onWillPop: () => _confirmQuit(context),
                            child: _QuestionsPanel(snapshot.data as Survey),
                          ))));
  }

  Future<bool> _confirmQuit(BuildContext context) async {
    final result = await showConfirmDialog(
      context,
      message: LocaleKeys.msg_quit_survey.tr(),
    );
    return result == true;
  }
}

class _QuestionsPanel extends StatefulWidget {
  final Survey survey;

  const _QuestionsPanel(this.survey, {super.key});

  @override
  State<_QuestionsPanel> createState() => _QuestionsPanelState();
}

class _QuestionsPanelState extends State<_QuestionsPanel> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.survey.title, style: textTheme.titleLarge),
      const Divider(),
      const SizedBox(height: 16),
      Expanded(
          child: PageView.builder(
        scrollBehavior: WebAndMobileScrollBehavior(),
        controller: _controller,
        itemCount: widget.survey.questions.length,
        itemBuilder: (_, index) {
          final question = widget.survey.questions[index];
          return _AnswersPanel(
            survey: widget.survey,
            question: question,
            onAnswerSelected: _onAnswerSelected,
          );
        },
        onPageChanged: (page) => setState(() => _currentPage = page),
      )),
      const SizedBox(height: 16),
      LinearProgressIndicator(
        value: (_currentPage + 1) / widget.survey.questions.length,
        backgroundColor: Colors.transparent,
        valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
      )
    ]);
  }

  _onAnswerSelected() async {
    if (widget.survey.isComplete) {
      // Survey completed!
      return push(SurveyCompletedScreen(widget.survey), replace: true);
    }
    // Go to next empty question
    for (int i = 0; i < widget.survey.questions.length; i++) {
      final index = (i + _currentPage) % widget.survey.questions.length;
      if (!widget.survey.currentSubmission
          .containsKey(widget.survey.questions[index])) {
        _controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;
      }
    }
  }
}

class _AnswersPanel extends StatefulWidget {
  final Survey survey;
  final SurveyQuestion question;
  final VoidCallback onAnswerSelected;

  const _AnswersPanel({
    super.key,
    required this.survey,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<_AnswersPanel> createState() => _AnswersPanelState();
}

class _AnswersPanelState extends State<_AnswersPanel> {
  SurveyAnswer? get selectedAnswer =>
      widget.survey.currentSubmission[widget.question];

  Widget get _randomBackground => Image.asset([
        'assets/images/splash-1.png',
        'assets/images/splash-2.png',
        'assets/images/splash-3.png'
      ].sample(1).single);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Opacity(opacity: 0.05, child: _randomBackground),
      Column(children: [
        Text(widget.question.title, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Expanded(
            child: ListView.builder(
          itemCount: widget.question.answers.length,
          itemBuilder: (context, index) =>
              _buildAnswer(widget.question.answers[index]),
        )),
      ]),
    ]);
  }

  Widget _buildAnswer(SurveyAnswer answer) => RadioListTile<SurveyAnswer>(
        title: Text(answer.title),
        subtitle: selectedAnswer != null
            ? _buildPreviousSubmissionsIndicator(answer)
            : null,
        activeColor: primaryColor,
        groupValue: selectedAnswer,
        value: answer,
        onChanged: selectedAnswer == null ? _onChanged : null,
      );

  _onChanged(final SurveyAnswer? answer) async {
    if (answer == null) return;

    // Save answer
    widget.survey.currentSubmission[widget.question] = answer;

    // Show previous submissions
    setState(() {});

    // Wait for the user to see the other results
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) widget.onAnswerSelected();
  }

  Widget _buildPreviousSubmissionsIndicator(SurveyAnswer answer) {
    // Compute the length of the indicator
    int votes = widget.survey.prevSubmissionsCount[widget.question]![answer]!;
    if (answer == selectedAnswer) votes++;
    int totalVotes =
        widget.survey.prevSubmissionsCount[widget.question]!.values.sum;
    if (selectedAnswer != null) totalVotes++;
    double prevSubmissionsValue = totalVotes > 0 ? votes / totalVotes : 0;
    debugPrint("$answer -> $votes / $totalVotes -> $prevSubmissionsValue");

    // Return the animated indicator
    return Row(children: [
      Expanded(
          child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: prevSubmissionsValue),
              builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(primaryColor),
                  ))),
      const SizedBox(width: 8),
      Text("${(prevSubmissionsValue * 100).round()}%"),
    ]);
  }
}
