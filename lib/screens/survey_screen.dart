import 'package:flutter/material.dart';

import '../widgets/scaffold.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      child: Center(child: Text("Survey")),
    );
  }
}
