import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/features/permission/controllers/permission_controller.dart';
import 'package:step_counter/src/features/step/routes/step_routes.dart';

class PermissionView extends StatefulWidget {
  const PermissionView({super.key});

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  late final PermissionController permissionController;

  @override
  void initState() {
    super.initState();
    permissionController = locator<PermissionController>();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _handlePermissionState();
    });
  }

  void _handlePermissionState() {
    if (permissionController.permissionModel.isGranted) {
      context.go(StepRoutes.steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Permission Check')),
      body: Center(
        child: ListenableBuilder(
          listenable: permissionController,
          builder: (context, child) {
            if (permissionController.permissionModel.isGranted) {
              return Text(
                'Permission granted. Navigating...',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              );
            } else {
              return Text(
                'Step permission is not granted. Please enable it in settings.',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              );
            }
          },
        ),
      ),
    );
  }
}
