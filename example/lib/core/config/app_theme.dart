import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff794f81),
      surfaceTint: Color(0xff794f81),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfffcd6ff),
      onPrimaryContainer: Color(0xff603768),
      secondary: Color(0xff6a596c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff3dbf2),
      onSecondaryContainer: Color(0xff524153),
      tertiary: Color(0xff82524d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdad6),
      onTertiaryContainer: Color(0xff673b36),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff1f1a1f),
      onSurfaceVariant: Color(0xff4c444c),
      outline: Color(0xff7e747d),
      outlineVariant: Color(0xffcfc3cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xffe8b5ef),
      primaryFixed: Color(0xfffcd6ff),
      onPrimaryFixed: Color(0xff300a3a),
      primaryFixedDim: Color(0xffe8b5ef),
      onPrimaryFixedVariant: Color(0xff603768),
      secondaryFixed: Color(0xfff3dbf2),
      onSecondaryFixed: Color(0xff241727),
      secondaryFixedDim: Color(0xffd6c0d6),
      onSecondaryFixedVariant: Color(0xff524153),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff33110e),
      tertiaryFixedDim: Color(0xfff5b7b0),
      onTertiaryFixedVariant: Color(0xff673b36),
      surfaceDim: Color(0xffe1d7de),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf1f8),
      surfaceContainer: Color(0xfff6ebf2),
      surfaceContainerHigh: Color(0xfff0e5ec),
      surfaceContainerHighest: Color(0xffeae0e7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4d2756),
      surfaceTint: Color(0xff794f81),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff895d91),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff403142),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7a677b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff532b27),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff92605b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff141014),
      onSurfaceVariant: Color(0xff3b343b),
      outline: Color(0xff585058),
      outlineVariant: Color(0xff746a73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xffe8b5ef),
      primaryFixed: Color(0xff895d91),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6f4577),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7a677b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff604f62),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff92605b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff774843),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcec4cb),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf1f8),
      surfaceContainer: Color(0xfff0e5ec),
      surfaceContainerHigh: Color(0xffe4dae1),
      surfaceContainerHighest: Color(0xffd9cfd6),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff421c4c),
      surfaceTint: Color(0xff794f81),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff623a6b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff362738),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff544456),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff47211d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff693d38),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff312a31),
      outlineVariant: Color(0xff4f474f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xffe8b5ef),
      primaryFixed: Color(0xff623a6b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff492353),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff544456),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3d2e3f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff693d38),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4f2723),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc0b6bd),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9eef5),
      surfaceContainer: Color(0xffeae0e7),
      surfaceContainerHigh: Color(0xffdcd2d9),
      surfaceContainerHighest: Color(0xffcec4cb),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe8b5ef),
      surfaceTint: Color(0xffe8b5ef),
      onPrimary: Color(0xff472150),
      primaryContainer: Color(0xff603768),
      onPrimaryContainer: Color(0xfffcd6ff),
      secondary: Color(0xffd6c0d6),
      onSecondary: Color(0xff3a2b3c),
      secondaryContainer: Color(0xff524153),
      onSecondaryContainer: Color(0xfff3dbf2),
      tertiary: Color(0xfff5b7b0),
      onTertiary: Color(0xff4c2521),
      tertiaryContainer: Color(0xff673b36),
      onTertiaryContainer: Color(0xffffdad6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff171217),
      onSurface: Color(0xffeae0e7),
      onSurfaceVariant: Color(0xffcfc3cd),
      outline: Color(0xff988e97),
      outlineVariant: Color(0xff4c444c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff794f81),
      primaryFixed: Color(0xfffcd6ff),
      onPrimaryFixed: Color(0xff300a3a),
      primaryFixedDim: Color(0xffe8b5ef),
      onPrimaryFixedVariant: Color(0xff603768),
      secondaryFixed: Color(0xfff3dbf2),
      onSecondaryFixed: Color(0xff241727),
      secondaryFixedDim: Color(0xffd6c0d6),
      onSecondaryFixedVariant: Color(0xff524153),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff33110e),
      tertiaryFixedDim: Color(0xfff5b7b0),
      onTertiaryFixedVariant: Color(0xff673b36),
      surfaceDim: Color(0xff171217),
      surfaceBright: Color(0xff3d373d),
      surfaceContainerLowest: Color(0xff110d11),
      surfaceContainerLow: Color(0xff1f1a1f),
      surfaceContainer: Color(0xff231e23),
      surfaceContainerHigh: Color(0xff2e282e),
      surfaceContainerHighest: Color(0xff393338),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffaceff),
      surfaceTint: Color(0xffe8b5ef),
      onPrimary: Color(0xff3b1544),
      primaryContainer: Color(0xffaf81b7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffedd5ec),
      onSecondary: Color(0xff2f2131),
      secondaryContainer: Color(0xff9f8a9f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd2cd),
      onTertiary: Color(0xff3f1b17),
      tertiaryContainer: Color(0xffba837d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff171217),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe5d9e3),
      outline: Color(0xffbaaeb8),
      outlineVariant: Color(0xff988d96),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff613969),
      primaryFixed: Color(0xfffcd6ff),
      onPrimaryFixed: Color(0xff23002e),
      primaryFixedDim: Color(0xffe8b5ef),
      onPrimaryFixedVariant: Color(0xff4d2756),
      secondaryFixed: Color(0xfff3dbf2),
      onSecondaryFixed: Color(0xff190c1c),
      secondaryFixedDim: Color(0xffd6c0d6),
      onSecondaryFixedVariant: Color(0xff403142),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff250705),
      tertiaryFixedDim: Color(0xfff5b7b0),
      onTertiaryFixedVariant: Color(0xff532b27),
      surfaceDim: Color(0xff171217),
      surfaceBright: Color(0xff494348),
      surfaceContainerLowest: Color(0xff0a060a),
      surfaceContainerLow: Color(0xff211c21),
      surfaceContainer: Color(0xff2c262b),
      surfaceContainerHigh: Color(0xff373136),
      surfaceContainerHighest: Color(0xff423c41),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeafe),
      surfaceTint: Color(0xffe8b5ef),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe4b2eb),
      onPrimaryContainer: Color(0xff1a0023),
      secondary: Color(0xffffeafe),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd2bcd2),
      onSecondaryContainer: Color(0xff130716),
      tertiary: Color(0xffffece9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff1b4ad),
      onTertiaryContainer: Color(0xff1e0302),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff171217),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffaecf6),
      outlineVariant: Color(0xffcbbfc9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff613969),
      primaryFixed: Color(0xfffcd6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe8b5ef),
      onPrimaryFixedVariant: Color(0xff23002e),
      secondaryFixed: Color(0xfff3dbf2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd6c0d6),
      onSecondaryFixedVariant: Color(0xff190c1c),
      tertiaryFixed: Color(0xffffdad6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff5b7b0),
      onTertiaryFixedVariant: Color(0xff250705),
      surfaceDim: Color(0xff171217),
      surfaceBright: Color(0xff554e54),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff231e23),
      surfaceContainer: Color(0xff342f34),
      surfaceContainerHigh: Color(0xff403a3f),
      surfaceContainerHighest: Color(0xff4b454b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
