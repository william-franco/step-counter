import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/permission/routes/permission_routes.dart';
import 'package:step_counter/src/features/settings/routes/setting_routes.dart';
import 'package:step_counter/src/features/step/routes/step_routes.dart';

class Routes {
  static String get home => PermissionRoutes.permisson;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [
      ...PermissionRoutes().routes,
      ...StepRoutes().routes,
      ...SettingRoutes().routes,
    ],
  );
}
