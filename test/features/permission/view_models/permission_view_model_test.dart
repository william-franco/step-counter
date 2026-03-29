import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:step_counter/src/features/permission/models/permission_model.dart';
import 'package:step_counter/src/features/permission/view_models/permission_view_model.dart';

import '../permission_mocks.mocks.dart';

void main() {
  group('PermissionViewModel Test', () {
    late MockPermissionRepository mockPermissionRepository;
    late PermissionViewModel viewModel;

    setUpAll(() {
      provideDummy<PermissionModel>(PermissionModel());
    });

    setUp(() {
      mockPermissionRepository = MockPermissionRepository();
      viewModel = PermissionViewModelImpl(
        permissionRepository: mockPermissionRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    // ---------------------------------------------------------------------------
    // Initial state
    // ---------------------------------------------------------------------------

    test('should start with a default PermissionModel', () {
      expect(viewModel.state, isA<PermissionModel>());
      expect(viewModel.state.isGranted, isFalse);
    });

    // ---------------------------------------------------------------------------
    // initStepPermission
    // ---------------------------------------------------------------------------

    group('initStepPermission', () {
      test('should emit PermissionModel with isGranted true '
          'when repository returns true', () async {
        // arrange
        when(
          mockPermissionRepository.checkAndRequestPermission(),
        ).thenAnswer((_) async => true);

        final emittedStates = <PermissionModel>[];
        viewModel.addListener(() => emittedStates.add(viewModel.state));

        // act
        await viewModel.initStepPermission();

        // assert
        expect(emittedStates.length, equals(1));
        expect(emittedStates.first.isGranted, isTrue);
        verify(mockPermissionRepository.checkAndRequestPermission()).called(1);
      });

      test('should emit PermissionModel with isGranted false '
          'when repository returns false', () async {
        // arrange
        when(
          mockPermissionRepository.checkAndRequestPermission(),
        ).thenAnswer((_) async => false);

        final emittedStates = <PermissionModel>[];
        viewModel.addListener(() => emittedStates.add(viewModel.state));

        // act
        await viewModel.initStepPermission();

        // assert
        expect(emittedStates.first.isGranted, isFalse);
      });

      test('should notify listeners exactly once per call', () async {
        // arrange
        when(
          mockPermissionRepository.checkAndRequestPermission(),
        ).thenAnswer((_) async => true);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        await viewModel.initStepPermission();

        // assert
        expect(notifyCount, equals(1));
      });

      test('should propagate exception thrown by repository', () async {
        // arrange
        when(
          mockPermissionRepository.checkAndRequestPermission(),
        ).thenThrow(Exception('Error requesting permission: denied'));

        // act & assert
        expect(() => viewModel.initStepPermission(), throwsA(isA<Exception>()));
      });

      test('should not emit new state when repository throws', () async {
        // arrange
        when(
          mockPermissionRepository.checkAndRequestPermission(),
        ).thenThrow(Exception('Error requesting permission: denied'));

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        try {
          await viewModel.initStepPermission();
        } catch (_) {}

        // assert
        expect(notifyCount, equals(0));
        expect(viewModel.state.isGranted, isFalse);
      });

      test(
        'should reflect correct state after multiple sequential calls',
        () async {
          // arrange
          when(
            mockPermissionRepository.checkAndRequestPermission(),
          ).thenAnswer((_) async => true);

          // act — first call grants permission
          await viewModel.initStepPermission();
          expect(viewModel.state.isGranted, isTrue);

          // second call — permission revoked
          when(
            mockPermissionRepository.checkAndRequestPermission(),
          ).thenAnswer((_) async => false);

          await viewModel.initStepPermission();

          // assert
          expect(viewModel.state.isGranted, isFalse);
          verify(
            mockPermissionRepository.checkAndRequestPermission(),
          ).called(2);
        },
      );
    });
  });
}
