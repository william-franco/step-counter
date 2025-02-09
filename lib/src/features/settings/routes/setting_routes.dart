import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/settings/views/setting_view.dart';

class SettingRoutes {
  static const String setting = '/setting';

  static final List<GoRoute> routes = [
    GoRoute(
      path: setting,
      pageBuilder: (context, state) => const MaterialPage(
        child: SettingView(),
      ),
    ),
  ];
}
