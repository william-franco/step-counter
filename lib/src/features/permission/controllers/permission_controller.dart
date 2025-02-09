import 'package:flutter/material.dart';
import 'package:step_counter/src/features/permission/models/permission_model.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';

typedef _Controller = ValueNotifier<PermissionModel>;

abstract interface class PermissionController extends _Controller {
  PermissionController() : super(PermissionModel());

  Future<void> initStepPermission();
}

class PermissionControllerImpl extends _Controller
    implements PermissionController {
  final PermissionRepository permissionRepository;

  PermissionControllerImpl({
    required this.permissionRepository,
  }) : super(PermissionModel());

  @override
  Future<void> initStepPermission() async {
    final isGranted = await permissionRepository.checkAndRequestPermission();
    value = PermissionModel(isGranted: isGranted);
  }
}
