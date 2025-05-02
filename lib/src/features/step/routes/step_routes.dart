import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/step/views/step_view.dart';

class StepRoutes {
  static String get steps => '/steps';

  final routes = [
    GoRoute(
      path: steps,
      builder: (context, state) {
        return const StepView();
      },
    ),
  ];
}
