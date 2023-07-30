import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/models/survey.dart';
import 'package:myopinionrocks_app/widgets/scaffold.dart';

import '../data/rest_client.dart';
import '../data/survey.dart';
import '../generated/locale_keys.g.dart';
import '../globals.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/loader.dart';
import 'registration_screen.dart';

class SurveyCompletedScreen extends StatelessWidget {
  final Survey survey;

  const SurveyCompletedScreen(this.survey, {super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        child: Center(
            child: FutureBuilder<SurveySubmissionResponse>(
                future: RestClient()
                    .createSurveyResult(SurveySubmissionRequest(survey)),
                builder:
                    (_, AsyncSnapshot<SurveySubmissionResponse> snapshot) =>
                        snapshot.connectionState != ConnectionState.done
                            ? MyLoader(LocaleKeys.msg_saving_survey.tr())
                            : _SurveyCompletedPanel(
                                snapshot.data as SurveySubmissionResponse))));
  }
}

class _SurveyCompletedPanel extends StatelessWidget {
  final SurveySubmissionResponse surveySubmission;

  const _SurveyCompletedPanel(this.surveySubmission, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset('assets/images/grow-rewards.png'),
      const SizedBox(height: 16),
      Text(
        LocaleKeys.msg_saved_survey.tr(),
        style: textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      Text(
        LocaleKeys.msg_join.tr(),
        style: textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      const Spacer(),
      MyButton(
        LocaleKeys.lbl_register.tr(),
        expanded: true,
        color: tertiaryColor,
        onPressed: () => push(context, const RegistrationScreen()),
      ),
    ]);
  }
}
