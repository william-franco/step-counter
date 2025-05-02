import 'package:flutter/material.dart';
import 'package:step_counter/src/features/settings/models/setting_model.dart';
import 'package:step_counter/src/features/settings/repositories/setting_repository.dart';

typedef _Controller = ChangeNotifier;

abstract interface class SettingController extends _Controller {
  SettingModel get settingModel;

  Future<void> loadTheme();
  Future<void> changeTheme({required bool isDarkTheme});
}

class SettingControllerImpl extends _Controller implements SettingController {
  final SettingRepository settingRepository;

  SettingControllerImpl({required this.settingRepository});

  SettingModel _settingModel = SettingModel();

  @override
  SettingModel get settingModel => _settingModel;

  @override
  Future<void> loadTheme() async {
    bool isDarkTheme = await settingRepository.readTheme();
    final settingModel = SettingModel(isDarkTheme: isDarkTheme);
    _emit(settingModel);
  }

  @override
  Future<void> changeTheme({required bool isDarkTheme}) async {
    await settingRepository.updateTheme(isDarkTheme: isDarkTheme);
    final settingModel = SettingModel(isDarkTheme: isDarkTheme);
    _emit(settingModel);
  }

  void _emit(SettingModel newValue) {
    _settingModel = newValue;
    notifyListeners();
    debugPrint('SettingController: ${_settingModel.isDarkTheme}');
  }
}
