import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_counter/src/features/settings/controllers/setting_controller.dart';

class SettingView extends StatelessWidget {
  final SettingController settingController;

  const SettingView({super.key, required this.settingController});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: const FlutterLogo(),
      applicationName: 'Step Counter',
      applicationVersion: 'Version 1.0.0',
      applicationLegalese: '\u{a9} 2025 William Franco',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Dark theme'),
              trailing: ListenableBuilder(
                listenable: settingController,
                builder: (context, child) {
                  return Switch(
                    value: settingController.settingModel.isDarkTheme,
                    onChanged: (bool isDarkTheme) {
                      settingController.changeTheme(isDarkTheme: isDarkTheme);
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
