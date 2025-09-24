import 'package:flutter/foundation.dart';
import 'package:step_counter/src/features/permission/models/permission_model.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';

typedef _ViewModel = ChangeNotifier;

abstract interface class PermissionViewModel extends _ViewModel {
  PermissionModel get permissionModel;

  Future<void> initStepPermission();
}

class PermissionViewModelImpl extends _ViewModel
    implements PermissionViewModel {
  final PermissionRepository permissionRepository;

  PermissionViewModelImpl({required this.permissionRepository});

  PermissionModel _permissionModel = PermissionModel();

  @override
  PermissionModel get permissionModel => _permissionModel;

  @override
  Future<void> initStepPermission() async {
    final isGranted = await permissionRepository.checkAndRequestPermission();
    _permissionModel = _permissionModel.copyWith(isGranted: isGranted);
    notifyListeners();
  }
}
