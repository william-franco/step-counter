import 'package:flutter/services.dart';
import 'package:step_counter/src/common/constants/value_constant.dart';

abstract interface class PermissionRepository {
  Future<bool> checkAndRequestPermission();
}

class PermissionRepositoryImpl implements PermissionRepository {
  static final _channel = MethodChannel(ValueConstant.pathChannel);

  @override
  Future<bool> checkAndRequestPermission() async {
    try {
      final bool isGranted = await _channel.invokeMethod(
        'checkAndRequestPermission',
      );
      return isGranted;
    } on PlatformException catch (error) {
      // return false;
      throw Exception('Erro ao solicitar a permissão: ${error.message}');
    }
  }
}
