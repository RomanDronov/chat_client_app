import 'package:flutter/material.dart';

import 'card_theme.dart';
import 'color_scheme.dart';
import 'text_theme.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: colorSchemeLight.surface,
  textTheme: textTheme,
  colorScheme: colorSchemeLight,
  cardTheme: cardThemeLight,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: colorSchemeLight.background,
  ),
);
final ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: textTheme,
  colorScheme: colorSchemeLight,
  cardTheme: cardThemeLight,
);
