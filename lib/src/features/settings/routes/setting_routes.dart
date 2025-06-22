import 'package:go_router/go_router.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/features/settings/controllers/setting_controller.dart';
import 'package:step_counter/src/features/settings/views/setting_view.dart';

class SettingRoutes {
  static String get setting => '/setting';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return SettingView(settingController: locator<SettingController>());
      },
    ),
  ];
}
