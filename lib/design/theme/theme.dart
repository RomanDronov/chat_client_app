import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'text_theme.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade100,
  textTheme: textTheme,
  colorScheme: colorSchemeLight,
);
final ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: textTheme,
  colorScheme: colorSchemeLight,
);
