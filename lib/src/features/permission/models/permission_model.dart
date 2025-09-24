class PermissionModel {
  final bool isGranted;

  PermissionModel({this.isGranted = false});

  PermissionModel copyWith({bool? isGranted}) =>
      PermissionModel(isGranted: isGranted ?? this.isGranted);
}
