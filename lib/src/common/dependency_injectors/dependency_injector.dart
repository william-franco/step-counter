import 'package:get_it/get_it.dart';
import 'package:step_counter/src/common/services/storage_service.dart';
import 'package:step_counter/src/features/permission/controllers/permission_controller.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';
import 'package:step_counter/src/features/settings/controllers/setting_controller.dart';
import 'package:step_counter/src/features/settings/repositories/setting_repository.dart';
import 'package:step_counter/src/features/step/controllers/step_controller.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startStorageService();
  _startFeaturePermission();
  _startFeatureStep();
  _startFeatureSetting();
}

void _startStorageService() {
  locator.registerLazySingleton<StorageService>(() => StorageServiceImpl());
}

void _startFeaturePermission() {
  locator.registerCachedFactory<PermissionRepository>(
    () => PermissionRepositoryImpl(),
  );
  locator.registerLazySingleton<PermissionController>(
    () => PermissionControllerImpl(
      permissionRepository: locator<PermissionRepository>(),
    ),
  );
}

void _startFeatureStep() {
  locator.registerCachedFactory<StepRepository>(() => StepRepositoryImpl());
  locator.registerLazySingleton<StepController>(
    () => StepControllerImpl(stepRepository: locator<StepRepository>()),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(storageService: locator<StorageService>()),
  );
  locator.registerLazySingleton<SettingController>(
    () =>
        SettingControllerImpl(settingRepository: locator<SettingRepository>()),
  );
}

Future<void> initDependencies() async {
  await locator<StorageService>().initStorage();
  await Future.wait([
    locator<SettingController>().loadTheme(),
    locator<PermissionController>().initStepPermission(),
  ]);
}

void resetDependencies() {
  locator.reset();
}

void resetFeatureSetting() {
  locator.unregister<SettingRepository>();
  locator.unregister<SettingController>();
  _startFeatureSetting();
}
