import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/settings/views/setting_view.dart';

class SettingRoutes {
  static String get setting => '/setting';

  final routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return const SettingView();
      },
    ),
  ];
}
