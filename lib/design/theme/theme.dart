import 'package:flutter/material.dart';

import 'text_theme.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.grey.shade100,
  textTheme: textTheme,
);
final ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: textTheme,
);
