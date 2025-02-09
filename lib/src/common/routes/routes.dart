import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: PermissionRoutes.permisson,
    routes: [
      ...PermissionRoutes.routes,
      ...ScannerRoutes.routes,
      ...SettingRoutes.routes,
    ],
  );
}
