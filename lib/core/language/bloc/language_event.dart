part of 'language_bloc.dart';

@freezed
class LanguageEvent with _$LanguageEvent {
  const factory LanguageEvent.initialized({
    required List<Locale> locales,
  }) = InitializedLanguageEvent;
  const factory LanguageEvent.localeChanged({
    required Locale locale,
  }) = LocaleChangedLanguageEvent;
}
