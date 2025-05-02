import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/permission/views/permission_view.dart';

class PermissionRoutes {
  static String get permisson => '/permisson';

  final routes = [
    GoRoute(
      path: permisson,
      builder: (context, state) {
        return const PermissionView();
      },
    ),
  ];
}
