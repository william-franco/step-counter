import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_counter/src/common/constants/value_constant.dart';
import 'package:step_counter/src/features/step/repositories/step_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StepRepository Test', () {
    late StepRepository repository;
    late MethodChannel channel;

    void setChannelHandler(Future<dynamic> Function(MethodCall call) handler) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannel(ValueConstant.pathChannel),
            handler,
          );
    }

    setUp(() {
      channel = MethodChannel(ValueConstant.pathChannel);
      repository = StepRepositoryImpl();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    // ---------------------------------------------------------------------------
    // startListening
    // ---------------------------------------------------------------------------

    group('startListening', () {
      test('should invoke startListening on the channel', () async {
        // arrange
        String? capturedMethod;
        setChannelHandler((call) async {
          capturedMethod = call.method;
          return null;
        });

        // act
        await repository.startListening();

        // assert
        expect(capturedMethod, equals('startListening'));
      });

      test(
        'should complete without error when channel call succeeds',
        () async {
          // arrange
          setChannelHandler((_) async => null);

          // act & assert
          await expectLater(repository.startListening(), completes);
        },
      );

      test('should propagate exception thrown by the channel', () async {
        // arrange
        setChannelHandler(
          (_) async => throw PlatformException(
            code: 'ERROR',
            message: 'Sensor unavailable',
          ),
        );

        // act & assert
        expect(() => repository.startListening(), throwsA(isA<Exception>()));
      });
    });

    // ---------------------------------------------------------------------------
    // getSteps
    // ---------------------------------------------------------------------------

    group('getSteps', () {
      test('should invoke getSteps on the channel', () async {
        // arrange
        String? capturedMethod;
        setChannelHandler((call) async {
          capturedMethod = call.method;
          return 42;
        });

        // act
        await repository.getSteps();

        // assert
        expect(capturedMethod, equals('getSteps'));
      });

      test('should return the int value received from the channel', () async {
        // arrange
        setChannelHandler((_) async => 1500);

        // act
        final result = await repository.getSteps();

        // assert
        expect(result, equals(1500));
      });

      test('should return 0 when channel returns null', () async {
        // arrange
        setChannelHandler((_) async => null);

        // act
        final result = await repository.getSteps();

        // assert
        expect(result, equals(0));
      });

      test('should propagate exception thrown by the channel', () async {
        // arrange
        setChannelHandler(
          (_) async => throw PlatformException(
            code: 'ERROR',
            message: 'Step counter unavailable',
          ),
        );

        // act & assert
        expect(() => repository.getSteps(), throwsA(isA<Exception>()));
      });
    });

    // ---------------------------------------------------------------------------
    // setStepUpdateListener
    // ---------------------------------------------------------------------------

    group('setStepUpdateListener', () {
      test(
        'should invoke the async callback when channel sends updateSteps',
        () async {
          // arrange
          int? receivedSteps;
          repository.setStepUpdateListener((steps) async {
            receivedSteps = steps;
          });

          // act — simulate native side pushing a step update
          await TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .handlePlatformMessage(
                ValueConstant.pathChannel,
                const StandardMethodCodec().encodeMethodCall(
                  const MethodCall('updateSteps', 300),
                ),
                (_) {},
              );

          // assert
          expect(receivedSteps, equals(300));
        },
      );

      test(
        'should not invoke the callback for unrelated channel methods',
        () async {
          // arrange
          bool callbackInvoked = false;
          repository.setStepUpdateListener((_) async {
            callbackInvoked = true;
          });

          // act
          await TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .handlePlatformMessage(
                ValueConstant.pathChannel,
                const StandardMethodCodec().encodeMethodCall(
                  const MethodCall('someOtherMethod', 999),
                ),
                (_) {},
              );

          // assert
          expect(callbackInvoked, isFalse);
        },
      );

      test(
        'should invoke the callback multiple times for sequential updates',
        () async {
          // arrange
          final receivedValues = <int>[];
          repository.setStepUpdateListener((steps) async {
            receivedValues.add(steps);
          });

          // act
          for (final value in [100, 200, 300]) {
            await TestDefaultBinaryMessengerBinding
                .instance
                .defaultBinaryMessenger
                .handlePlatformMessage(
                  ValueConstant.pathChannel,
                  const StandardMethodCodec().encodeMethodCall(
                    MethodCall('updateSteps', value),
                  ),
                  (_) {},
                );
          }

          // assert
          expect(receivedValues, equals([100, 200, 300]));
        },
      );

      test(
        'should await the async callback before completing the handler',
        () async {
          // arrange
          final callOrder = <String>[];
          repository.setStepUpdateListener((steps) async {
            callOrder.add('callback_start');
            await Future<void>.delayed(Duration.zero);
            callOrder.add('callback_end');
          });

          // act
          await TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .handlePlatformMessage(
                ValueConstant.pathChannel,
                const StandardMethodCodec().encodeMethodCall(
                  const MethodCall('updateSteps', 50),
                ),
                (_) {},
              );

          // assert
          expect(callOrder, equals(['callback_start', 'callback_end']));
        },
      );
    });
  });
}
