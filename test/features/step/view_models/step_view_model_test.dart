import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:step_counter/src/features/step/models/step_model.dart';
import 'package:step_counter/src/features/step/view_models/step_view_model.dart';

import '../step_mocks.mocks.dart';

void main() {
  group('StepViewModel Test', () {
    late MockStepRepository mockStepRepository;
    late StepViewModel viewModel;

    setUpAll(() {
      provideDummy<StepModel>(StepModel());
    });

    setUp(() {
      mockStepRepository = MockStepRepository();
      viewModel = StepViewModelImpl(stepRepository: mockStepRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    // ---------------------------------------------------------------------------
    // Initial state
    // ---------------------------------------------------------------------------

    test('should start with a default StepModel', () {
      expect(viewModel.state, isA<StepModel>());
      expect(viewModel.state.steps, equals(0));
    });

    // ---------------------------------------------------------------------------
    // initialize
    // ---------------------------------------------------------------------------

    group('initialize', () {
      test('should call setStepUpdateListener, startListening and getSteps '
          'in the correct order', () async {
        // arrange
        when(mockStepRepository.setStepUpdateListener(any)).thenAnswer((_) {});
        when(mockStepRepository.startListening()).thenAnswer((_) async {
          return;
        });
        when(mockStepRepository.getSteps()).thenAnswer((_) async => 0);

        // act
        await viewModel.initialize();

        // assert
        verifyInOrder([
          mockStepRepository.setStepUpdateListener(any),
          mockStepRepository.startListening(),
          mockStepRepository.getSteps(),
        ]);
      });

      test(
        'should emit StepModel with initial step count returned by getSteps',
        () async {
          // arrange
          when(
            mockStepRepository.setStepUpdateListener(any),
          ).thenAnswer((_) {});
          when(mockStepRepository.startListening()).thenAnswer((_) async {
            return;
          });
          when(mockStepRepository.getSteps()).thenAnswer((_) async => 500);

          final emittedStates = <StepModel>[];
          viewModel.addListener(() => emittedStates.add(viewModel.state));

          // act
          await viewModel.initialize();

          // assert
          expect(emittedStates.length, equals(1));
          expect(emittedStates.first.steps, equals(500));
        },
      );

      test('should not emit when getSteps returns 0 '
          '(equal to default state — guard prevents emission)', () async {
        // arrange
        when(mockStepRepository.setStepUpdateListener(any)).thenAnswer((_) {});
        when(mockStepRepository.startListening()).thenAnswer((_) async {
          return;
        });
        when(mockStepRepository.getSteps()).thenAnswer((_) async => 0);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        await viewModel.initialize();

        // assert
        expect(notifyCount, equals(0));
        expect(viewModel.state.steps, equals(0));
      });

      test(
        'should register updateSteps as the listener and it works when invoked',
        () async {
          // arrange
          Future<void> Function(int)? registeredCallback;
          when(mockStepRepository.setStepUpdateListener(any)).thenAnswer((inv) {
            registeredCallback =
                inv.positionalArguments.first as Future<void> Function(int);
          });
          when(mockStepRepository.startListening()).thenAnswer((_) async {
            return;
          });
          when(mockStepRepository.getSteps()).thenAnswer((_) async => 0);

          await viewModel.initialize();

          // act — invoke the registered callback directly
          await registeredCallback!(100);

          // assert
          expect(viewModel.state.steps, equals(100));
        },
      );
    });

    // ---------------------------------------------------------------------------
    // updateSteps
    // ---------------------------------------------------------------------------

    group('updateSteps', () {
      test('should emit StepModel with new step count '
          'when value differs from current state', () async {
        // arrange
        final emittedStates = <StepModel>[];
        viewModel.addListener(() => emittedStates.add(viewModel.state));

        // act
        await viewModel.updateSteps(250);

        // assert
        expect(emittedStates.length, equals(1));
        expect(emittedStates.first.steps, equals(250));
      });

      test('should notify listeners exactly once when value changes', () async {
        // arrange
        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        await viewModel.updateSteps(100);

        // assert
        expect(notifyCount, equals(1));
      });

      test('should NOT emit when new value equals current state '
          '(guard: state.steps != steps)', () async {
        // arrange — default state is 0
        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        await viewModel.updateSteps(0);

        // assert
        expect(notifyCount, equals(0));
        expect(viewModel.state.steps, equals(0));
      });

      test('should NOT emit on a repeated call with the same value', () async {
        // arrange — advance state first
        await viewModel.updateSteps(100);

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        await viewModel.updateSteps(100);

        // assert
        expect(notifyCount, equals(0));
      });

      test('should emit on every call when each value is different', () async {
        // arrange
        final emittedStates = <StepModel>[];
        viewModel.addListener(() => emittedStates.add(viewModel.state));

        // act
        await viewModel.updateSteps(100);
        await viewModel.updateSteps(200);
        await viewModel.updateSteps(300);

        // assert
        expect(emittedStates.length, equals(3));
        expect(emittedStates.map((s) => s.steps), equals([100, 200, 300]));
      });

      test(
        'should update state correctly after a sequence with duplicate values',
        () async {
          // act
          await viewModel.updateSteps(50); // emits
          await viewModel.updateSteps(50); // blocked — same value
          await viewModel.updateSteps(75); // emits

          // assert
          expect(viewModel.state.steps, equals(75));
        },
      );

      test(
        'should update state via the listener callback registered in initialize',
        () async {
          // arrange — capture the callback inline so the stub is registered
          // before initialize() runs and is not overwritten afterwards.
          Future<void> Function(int)? registeredCallback;
          when(mockStepRepository.setStepUpdateListener(any)).thenAnswer((inv) {
            registeredCallback =
                inv.positionalArguments.first as Future<void> Function(int);
          });
          when(mockStepRepository.startListening()).thenAnswer((_) async {
            return;
          });
          when(mockStepRepository.getSteps()).thenAnswer((_) async => 0);

          // initialize fills registeredCallback via the stub above
          await viewModel.initialize();

          // act — simulate native side pushing a new step count
          await registeredCallback!(800);

          // assert
          expect(viewModel.state.steps, equals(800));
        },
      );
    });
  });
}
