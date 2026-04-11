import 'package:flutter/foundation.dart';
import 'package:step_counter/src/common/state_management/state_management.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

typedef _ViewModel = StateManagement<StepModel>;

abstract interface class StepViewModel extends _ViewModel {
  Future<void> initialize();
  Future<void> updateSteps(int steps);
}

class StepViewModelImpl extends _ViewModel implements StepViewModel {
  final StepRepository stepRepository;

  StepViewModelImpl({required this.stepRepository});

  @override
  StepModel build() => StepModel();

  @override
  Future<void> initialize() async {
    stepRepository.setStepUpdateListener(updateSteps);
    await stepRepository.startListening();
    await updateSteps(await stepRepository.getSteps());
  }

  @override
  Future<void> updateSteps(int steps) async {
    if (state.steps != steps) {
      final model = state.copyWith(steps: steps);
      _emit(model);
    }
  }

  void _emit(StepModel newState) {
    emitState(newState);
    debugPrint('StepViewModel: ${state.steps}');
  }
}
