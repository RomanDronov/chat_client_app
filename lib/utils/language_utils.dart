import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getLanguageNameByLocale(BuildContext context, Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizations.of(context).languageEnglish;
    case 'ru':
      return AppLocalizations.of(context).languageRussian;
  }

  return locale.languageCode.toUpperCase();
}
