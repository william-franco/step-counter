import 'package:flutter/material.dart';
import 'package:step_counter/src/common/dependency_injectors/dependency_injector.dart';
import 'package:step_counter/src/common/routes/routes.dart';
import 'package:step_counter/src/features/settings/view_models/setting_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  final Routes appRoutes = Routes();
  runApp(
    MyApp(appRoutes: appRoutes, settingViewModel: locator<SettingViewModel>()),
  );
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;
  final SettingViewModel settingViewModel;

  const MyApp({
    super.key,
    required this.appRoutes,
    required this.settingViewModel,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingViewModel,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Barcode Scanner App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingViewModel.settingModel.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
