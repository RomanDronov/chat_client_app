import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_description.freezed.dart';

@freezed
class InfoDescription with _$InfoDescription {
  const factory InfoDescription({
    required InfoType type,
    required String title,
    required String description,
    required InfoButton firstButton,
    @Default(null) InfoButton? secondButton,
  }) = _InfoDescription;
}

enum InfoType {
  warning,
}

@freezed
class InfoButton with _$InfoButton {
  const factory InfoButton({
    required String label,
    required void Function() onPressed,
  }) = _InfoButton;
}
