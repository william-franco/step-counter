import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_counter/src/common/constants/value_constant.dart';
import 'package:step_counter/src/features/permission/repositories/permission_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PermissionRepository Test', () {
    late PermissionRepository repository;
    late MethodChannel channel;

    void setChannelHandler(Future<dynamic> Function(MethodCall call) handler) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    }

    setUp(() {
      channel = MethodChannel(ValueConstant.pathChannel);
      repository = PermissionRepositoryImpl();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    // ---------------------------------------------------------------------------
    // checkAndRequestPermission
    // ---------------------------------------------------------------------------

    group('checkAndRequestPermission', () {
      test('should invoke checkAndRequestPermission on the channel', () async {
        // arrange
        String? capturedMethod;
        setChannelHandler((call) async {
          capturedMethod = call.method;
          return true;
        });

        // act
        await repository.checkAndRequestPermission();

        // assert
        expect(capturedMethod, equals('checkAndRequestPermission'));
      });

      test('should return true when channel returns true', () async {
        // arrange
        setChannelHandler((_) async => true);

        // act
        final result = await repository.checkAndRequestPermission();

        // assert
        expect(result, isTrue);
      });

      test('should return false when channel returns false', () async {
        // arrange
        setChannelHandler((_) async => false);

        // act
        final result = await repository.checkAndRequestPermission();

        // assert
        expect(result, isFalse);
      });

      test('should throw Exception with correct message '
          'when channel throws PlatformException', () async {
        // arrange
        setChannelHandler(
          (_) async => throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Microphone access denied',
          ),
        );

        // act & assert
        expect(
          () => repository.checkAndRequestPermission(),
          throwsA(
            predicate<Exception>(
              (e) =>
                  e.toString().contains('Error requesting permission:') &&
                  e.toString().contains('Microphone access denied'),
            ),
          ),
        );
      });

      test(
        'should only catch PlatformException — generic exceptions propagate',
        () async {
          // arrange
          setChannelHandler((_) async => throw Exception('Generic failure'));

          // act & assert
          expect(
            () => repository.checkAndRequestPermission(),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
