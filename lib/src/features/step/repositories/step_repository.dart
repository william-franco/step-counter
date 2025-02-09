import 'package:flutter/services.dart';
import 'package:step_counter/src/common/constants/constants.dart';

abstract interface class StepRepository {
  Future<void> startListening();

  Future<int> getSteps();

  void setStepUpdateListener(Future<void> Function(int) callback);
}

class StepRepositoryImpl implements StepRepository {
  static const MethodChannel _channel = MethodChannel(Constants.pathChannel);

  @override
  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');
  }

  @override
  Future<int> getSteps() async {
    return await _channel.invokeMethod<int>('getSteps') ?? 0;
  }

  @override
  void setStepUpdateListener(Future<void> Function(int) callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'updateSteps') {
        await callback(call.arguments);
      }
    });
  }
}
