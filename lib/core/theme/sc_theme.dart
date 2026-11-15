import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ScColors {
  static const magenta500 = Color(0xFFEC13A4);
  static const magentaHover = Color(0xFFD40F93);
  static const magenta600 = Color(0xFFE41B68);
  static const magenta100 = Color(0xFFFCE7F5);
  static const magenta50 = Color(0xFFFDF2FB);
  static const purple700 = Color(0xFF37207B);
  static const mauve500 = Color(0xFF89617C);

  static const ink = Color(0xFF181116);
  static const slate900 = Color(0xFF0F172A);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const white = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF8F6F7);

  static const green500 = Color(0xFF10B981);
  static const green600 = Color(0xFF22C55E);
  static const green50 = Color(0xFFECFDF5);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const red100 = Color(0xFFFEE2E2);
  static const red50 = Color(0xFFFEF2F2);
  static const amber800 = Color(0xFF92400E);
  static const amber100 = Color(0xFFFEF3C7);

  static const brand = magenta500;
  static const brandSecondary = magenta600;
  static const brandTint = magenta100;
  static const surfaceCard = white;
  static const surfaceSunken = slate100;
  static const textHeading = ink;
  static const textPrimary = slate900;
  static const textBody = slate600;
  static const textSecondary = slate500;
  static const textMuted = slate400;
  static const textSubtle = mauve500;
  static const borderHairline = slate100;
  static const borderDefault = slate200;
}

abstract class ScShadows {
  static const card = [
    BoxShadow(color: ScColors.slate100, spreadRadius: 1),
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const brand = [
    BoxShadow(
        color: Color(0x4DEC13A4),
        offset: Offset(0, 10),
        blurRadius: 15,
        spreadRadius: -3),
    BoxShadow(
        color: Color(0x4DEC13A4),
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -4),
  ];

  static const sheet = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, -8), blurRadius: 30),
  ];

  static const lg = [
    BoxShadow(color: Color(0x24000000), offset: Offset(0, 10), blurRadius: 26),
  ];
}

abstract class ScMotion {
  static const easeOut = Cubic(0.16, 1, 0.3, 1);
  static const fast = Duration(milliseconds: 140);
  static const base = Duration(milliseconds: 200);
}

abstract class ScText {
  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = ScColors.textPrimary,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height != null ? height / size : null,
        letterSpacing: spacing,
      );

  static TextStyle display({
    double size = 47,
    FontWeight weight = FontWeight.w700,
    Color color = ScColors.brand,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height != null ? height / size : null,
        letterSpacing: spacing,
      );

  static TextStyle mono({
    double size = 13,
    FontWeight weight = FontWeight.w500,
    Color color = ScColors.textPrimary,
    double? spacing,
  }) =>
      GoogleFonts.robotoMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
      );

  static TextStyle title([Color color = ScColors.textHeading]) =>
      sans(size: 26, weight: FontWeight.w800, color: color, height: 31, spacing: -0.6);

  static TextStyle headline([Color color = ScColors.textHeading]) =>
      sans(size: 30, weight: FontWeight.w800, color: color, height: 38, spacing: -0.6);

  static TextStyle sub([Color color = ScColors.textSubtle]) =>
      sans(size: 15, weight: FontWeight.w500, color: color, height: 22);

  static TextStyle micro([Color color = ScColors.textMuted]) =>
      sans(size: 11, weight: FontWeight.w700, color: color, spacing: 1);
}

ThemeData buildScTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ScColors.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ScColors.brand,
      primary: ScColors.brand,
      surface: ScColors.canvas,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
  return base.copyWith(
    textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
  );
}
