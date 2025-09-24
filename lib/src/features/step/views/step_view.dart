import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/settings/routes/setting_routes.dart';
import 'package:step_counter/src/features/step/view_models/step_view_model.dart';

class StepView extends StatefulWidget {
  final StepViewModel stepViewModel;

  const StepView({super.key, required this.stepViewModel});

  @override
  State<StepView> createState() => _StepViewState();
}

class _StepViewState extends State<StepView> {
  @override
  void initState() {
    super.initState();
    widget.stepViewModel.initialize();
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
          listenable: widget.stepViewModel,
          builder: (context, child) {
            return Text(
              'Steps: ${widget.stepViewModel.stepModel.steps}',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
