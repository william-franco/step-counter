import 'package:flutter/material.dart';
import 'package:step_counter/src/features/permission/models/permission_model.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';

typedef _Controller = ChangeNotifier;

abstract interface class PermissionController extends _Controller {
  PermissionModel get permissionModel;

  Future<void> initStepPermission();
}

class PermissionControllerImpl extends _Controller
    implements PermissionController {
  final PermissionRepository permissionRepository;

  PermissionControllerImpl({required this.permissionRepository});

  PermissionModel _permissionModel = PermissionModel();

  @override
  PermissionModel get permissionModel => _permissionModel;

  @override
  Future<void> initStepPermission() async {
    final isGranted = await permissionRepository.checkAndRequestPermission();
    _permissionModel = PermissionModel(isGranted: isGranted);
    notifyListeners();
  }
}
