import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/permission/view_models/permission_view_model.dart';
import 'package:step_counter/src/features/step/routes/step_routes.dart';

class PermissionView extends StatefulWidget {
  final PermissionViewModel permissionViewModel;

  const PermissionView({super.key, required this.permissionViewModel});

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _handlePermissionState();
    });
  }

  void _handlePermissionState() {
    if (widget.permissionViewModel.permissionModel.isGranted) {
      context.go(StepRoutes.steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Permission Check')),
      body: Center(
        child: ListenableBuilder(
          listenable: widget.permissionViewModel,
          builder: (context, child) {
            if (widget.permissionViewModel.permissionModel.isGranted) {
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
