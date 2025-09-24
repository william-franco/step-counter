class StepModel {
  final int steps;

  StepModel({this.steps = 0});

  StepModel copyWith({int? steps}) => StepModel(steps: steps ?? this.steps);
}
