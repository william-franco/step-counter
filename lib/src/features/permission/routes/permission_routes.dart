import 'package:go_router/go_router.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/features/permission/controllers/permission_controller.dart';
import 'package:step_counter/src/features/permission/views/permission_view.dart';

class PermissionRoutes {
  static String get permisson => '/permisson';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: permisson,
      builder: (context, state) {
        return PermissionView(
          permissionController: locator<PermissionController>(),
        );
      },
    ),
  ];
}
