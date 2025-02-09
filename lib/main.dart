import 'package:flutter/material.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SettingModel>(
      valueListenable: locator<SettingController>(),
      builder: (context, settingModel, widget) {
        return MaterialApp.router(
          title: 'Barcode Scanner App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          themeMode:
              settingModel.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routerConfig: Routes.routes,
        );
      },
    );
  }
}
