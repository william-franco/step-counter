import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/settings/routes/setting_routes.dart';
import 'package:step_counter/src/features/step/controllers/step_controller.dart';

class StepView extends StatefulWidget {
  final StepController stepController;

  const StepView({super.key, required this.stepController});

  @override
  State<StepView> createState() => _StepViewState();
}

class _StepViewState extends State<StepView> {
  late final StepController stepController;

  @override
  void initState() {
    super.initState();
    stepController = widget.stepController;
    stepController.initialize();
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
              context.push(SettingRoutes.setting);
            },
          ),
        ],
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: stepController,
          builder: (context, child) {
            return Text(
              'Steps: ${stepController.stepModel.steps}',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
