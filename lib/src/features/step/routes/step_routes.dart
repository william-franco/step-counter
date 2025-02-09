import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/step/views/step_view.dart';

class StepRoutes {
  static const String steps = '/steps';

  static final List<GoRoute> routes = [
    GoRoute(
      path: steps,
      pageBuilder: (context, state) => const MaterialPage(
        child: StepView(),
      ),
    ),
  ];
}
