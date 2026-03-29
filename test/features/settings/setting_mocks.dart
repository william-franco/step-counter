import 'package:mockito/annotations.dart';
import 'package:step_counter/src/common/services/storage_service.dart';
import 'package:step_counter/src/features/settings/repositories/setting_repository.dart';

@GenerateMocks([StorageService, SettingRepository])
void main() {}
