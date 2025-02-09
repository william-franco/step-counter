import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/permission/views/permission_view.dart';

class PermissionRoutes {
  static const String permisson = '/permission';

  static final List<GoRoute> routes = [
    GoRoute(
      path: permisson,
      pageBuilder: (context, state) => const MaterialPage(
        child: PermissionView(),
      ),
    ),
  ];
}
