import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_description.freezed.dart';

@freezed
class AlertDescription with _$AlertDescription {
  const factory AlertDescription({
    required AlertType type,
    required String title,
    required String description,
    @Default(true) bool isDismissible,
  }) = _AlertDescription;
}

enum AlertType {
  warning,
}
