import 'package:flutter/material.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

typedef _Controller = ChangeNotifier;

abstract interface class StepController extends _Controller {
  StepModel get stepModel;

  Future<void> initialize();
  Future<void> updateSteps(int steps);
}

class StepControllerImpl extends _Controller implements StepController {
  final StepRepository stepRepository;

  StepControllerImpl({required this.stepRepository});

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
      _stepModel = StepModel(steps: steps);
      notifyListeners();
    }
  }
}
