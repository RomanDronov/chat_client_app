import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_scheme.dart';

final textTheme = TextTheme(
  headline6: GoogleFonts.didactGothic(
    color: colorSchemeLight.onBackground,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  ),
  headline5: GoogleFonts.didactGothic(
    color: colorSchemeLight.onBackground,
    fontWeight: FontWeight.w300,
    letterSpacing: 1,
  ),
  headline4: GoogleFonts.didactGothic(
    color: colorSchemeLight.onBackground,
    fontWeight: FontWeight.w300,
    letterSpacing: 1,
  ),
  bodyText1: GoogleFonts.commissioner(
    color: colorSchemeLight.onBackground,
  ),
  bodyText2: GoogleFonts.commissioner(
    color: colorSchemeLight.onBackground,
  ),
  subtitle1: GoogleFonts.commissioner(
    color: colorSchemeLight.onBackground,
  ),
  subtitle2: GoogleFonts.commissioner(
    color: colorSchemeLight.onBackground,
  ),
);
