part of 'language_bloc.dart';

@freezed
class LanguageState with _$LanguageState {
  const factory LanguageState({
    required List<Locale> locales,
    required Locale locale,
  }) = _LanguageState;
}
