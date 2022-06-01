import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/design/theme/theme.dart';
import '../core/language/bloc/language_bloc.dart';
import '../feature/start_up/start_up_screen.dart';
import '../main.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageBloc>(
      create: (context) => LanguageBloc(sharedPreferences)
        ..add(const LanguageEvent.initialized(locales: AppLocalizations.supportedLocales)),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: state.locales,
            locale: state.locale,
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            home: const StartUpScreen(),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}
