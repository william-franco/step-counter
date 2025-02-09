import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/features/step/controllers/step_controller.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';

class StepView extends StatefulWidget {
  const StepView({super.key});

  @override
  State<StepView> createState() => _StepViewState();
}

class _StepViewState extends State<StepView> {
  late final StepController stepController;

  @override
  void initState() {
    super.initState();
    stepController = locator<StepController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Step counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('');
            },
          ),
        ],
      ),
      body: Center(
        child: ValueListenableBuilder<StepModel>(
          valueListenable: stepController,
          builder: (context, stepModel, child) {
            return Text(
              'Steps: ${stepModel.steps}',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
