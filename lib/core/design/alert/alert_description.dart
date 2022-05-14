import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_description.freezed.dart';

@freezed
class AlertDescription with _$AlertDescription {
  const factory AlertDescription({
    required AlertType type,
    required String title,
    required String description,
    @Default(true) bool isDismissible,
    required AlertButton firstButton,
    @Default(null) AlertButton? secondButton,
  }) = _AlertDescription;
}

enum AlertType {
  warning,
}

@freezed
class AlertButton with _$AlertButton {
  const factory AlertButton({
    required String label,
    required void Function() onPressed,
  }) = _AlertButton;
}
