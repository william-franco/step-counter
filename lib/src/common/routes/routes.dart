import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/permission/routes/permission_routes.dart';
import 'package:step_counter/src/features/step/routes/step_routes.dart';

class Routes {
  static final GoRouter routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: PermissionRoutes.permisson,
    routes: [
      ...PermissionRoutes.routes,
      ...StepRoutes.routes,
      ...SettingRoutes.routes,
    ],
  );
}
