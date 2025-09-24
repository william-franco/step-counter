import 'package:flutter/foundation.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

typedef _ViewModel = ChangeNotifier;

abstract interface class StepViewModel extends _ViewModel {
  StepModel get stepModel;

  Future<void> initialize();
  Future<void> updateSteps(int steps);
}

class StepViewModelImpl extends _ViewModel implements StepViewModel {
  final StepRepository stepRepository;

  StepViewModelImpl({required this.stepRepository});

  StepModel _stepModel = StepModel();

  @override
  StepModel get stepModel => _stepModel;

  @override
  Future<void> initialize() async {
    stepRepository.setStepUpdateListener(updateSteps);
    await stepRepository.startListening();
    await updateSteps(await stepRepository.getSteps());
  }

  @override
  Future<void> updateSteps(int steps) async {
    if (_stepModel.steps != steps) {
      _stepModel = _stepModel.copyWith(steps: steps);
      notifyListeners();
    }
  }
}
