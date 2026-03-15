import 'package:flutter/foundation.dart';
import 'package:step_counter/src/common/state_management/state_management.dart';
import 'package:step_counter/src/features/permission/models/permission_model.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';

typedef _ViewModel = StateManagement<PermissionModel>;

abstract interface class PermissionViewModel extends _ViewModel {
  PermissionViewModel(super.initialState);

  Future<void> initStepPermission();
}

class PermissionViewModelImpl extends _ViewModel
    implements PermissionViewModel {
  final PermissionRepository permissionRepository;

  PermissionViewModelImpl({required this.permissionRepository})
    : super(PermissionModel());

  @override
  Future<void> initStepPermission() async {
    final isGranted = await permissionRepository.checkAndRequestPermission();
    final model = state.copyWith(isGranted: isGranted);
    _emit(model);
  }

  void _emit(PermissionModel newState) {
    emitState(newState);
    debugPrint('PermissionViewModel: ${state.isGranted}');
  }
}
