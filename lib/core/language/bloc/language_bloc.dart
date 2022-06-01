import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_bloc.freezed.dart';
part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences _preferences;
  LanguageBloc(this._preferences)
      : super(
          const LanguageState(
            locale: Locale('en'),
            locales: [Locale('en'), Locale('ru')],
          ),
        ) {
    on<InitializedLanguageEvent>(_onInitialized);
    on<LocaleChangedLanguageEvent>(_onLocaleChanged);
  }

  FutureOr<void> _onInitialized(
    InitializedLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final String? localeString = _preferences.getString('locale');
    if (localeString == null) {
      await _preferences.setString('locale', state.locale.languageCode);
      emit(LanguageState(locale: const Locale('en'), locales: state.locales));
    } else {
      emit(LanguageState(locale: Locale(localeString), locales: state.locales));
    }
  }

  FutureOr<void> _onLocaleChanged(
    LocaleChangedLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageState(locale: event.locale, locales: state.locales));
    await _preferences.setString('locale', state.locale.languageCode);
  }
}
