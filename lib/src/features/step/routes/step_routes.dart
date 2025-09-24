import 'package:go_router/go_router.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/features/step/view_models/step_view_model.dart';
import 'package:step_counter/src/features/step/views/step_view.dart';

class StepRoutes {
  static String get steps => '/steps';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: steps,
      builder: (context, state) {
        return StepView(stepViewModel: locator<StepViewModel>());
      },
    ),
  ];
}
