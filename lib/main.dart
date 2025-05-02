import 'package:flutter/material.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/common/routes/routes.dart';
import 'package:step_counter/src/features/settings/controllers/setting_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingController settingController = locator<SettingController>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: locator<SettingController>(),
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Barcode Scanner App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode:
              settingController.settingModel.isDarkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,
          routerConfig: Routes().routes,
        );
      },
    );
  }
}
