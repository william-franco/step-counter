import 'package:flutter/material.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

typedef _Controller = ValueNotifier<StepModel>;

abstract interface class StepController extends _Controller {
  StepController() : super(StepModel());

  Future<void> initialize();

  Future<void> updateSteps(int steps);
}

class StepControllerImpl extends _Controller implements StepController {
  final StepRepository stepRepository;

  StepControllerImpl({required this.stepRepository}) : super(StepModel()) {
    initialize();
  }

  @override
  Future<void> initialize() async {
    stepRepository.setStepUpdateListener(updateSteps);
    await stepRepository.startListening();
    await updateSteps(await stepRepository.getSteps());
  }

  @override
  Future<void> updateSteps(int steps) async {
    if (value.steps != steps) {
      value = StepModel(steps: steps);
    }
  }
}
