import 'package:get_it/get_it.dart';
import 'package:step_counter/src/common/services/storage_service.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startStorageService();
  _startFeaturePermission();
  _startFeatureScanner();
  _startFeatureSetting();
}

void _startStorageService() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );
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

void _startFeatureScanner() {
  locator.registerLazySingleton<ScannerController>(
    () => ScannerControllerImpl(),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(
      storageService: locator<StorageService>(),
    ),
  );
  locator.registerLazySingleton<SettingController>(
    () => SettingControllerImpl(
      settingRepository: locator<SettingRepository>(),
    ),
  );
}

Future<void> initDependencies() async {
  await Future.wait([
    locator<SettingController>().loadTheme(),
    locator<PermissionController>().initCameraPermission(),
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
