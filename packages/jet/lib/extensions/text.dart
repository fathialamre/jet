import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension TextThemeExtensions on Text {
  // Title variants
  Text titleSmall(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.titleSmall?.fontSize),
    key,
  );

  Text titleMedium(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),
    key,
  );

  Text titleLarge(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.titleLarge?.fontSize),
    key,
  );

  // Body variants
  Text bodySmall(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),
    key,
  );

  Text bodyMedium(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
    key,
  );

  Text bodyLarge(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize),
    key,
  );

  // Label variants
  Text labelSmall(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
    key,
  );

  Text labelMedium(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize),
    key,
  );

  Text labelLarge(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize),
    key,
  );

  // Headline variants
  Text headlineSmall(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize),
    key,
  );

  Text headlineMedium(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize),
    key,
  );

  Text headlineLarge(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize),
    key,
  );

  // Display variants
  Text displaySmall(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.displaySmall?.fontSize),
    key,
  );

  Text displayMedium(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.displayMedium?.fontSize),
    key,
  );

  Text displayLarge(BuildContext context, {Key? key}) => _styledText(
    context,
    TextStyle(fontSize: Theme.of(context).textTheme.displayLarge?.fontSize),
    key,
  );

  // Added styling extensions
  Text bold() => _applyStyle(const TextStyle(fontWeight: FontWeight.bold));

  Text center() => copyWith(textAlign: TextAlign.center);

  Text underline() =>
      _applyStyle(const TextStyle(decoration: TextDecoration.underline));

  Text color(Color color) => _applyStyle(TextStyle(color: color));

  Text fontSize(double size) => _applyStyle(TextStyle(fontSize: size));

  /// Helper to merge styles dynamically
  Text _applyStyle(TextStyle style) {
    return Text(
      data ?? '',
      key: key,
      style: (this.style ?? const TextStyle()).merge(style),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  Text _styledText(BuildContext context, TextStyle? style, Key? key) {
    return Text(
      data ?? '',
      key: key ?? this.key,
      style: (style ?? const TextStyle()).merge(this.style),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  // Improved copyWith extension for more flexibility
  Text copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    Key? key,
  }) {
    return Text(
      data ?? this.data ?? '',
      key: key ?? this.key,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }
}

extension OrderIdFormatter on int {
  String toOrderId() {
    final formatter = intl.NumberFormat('00000'); // Ensures at least 5 digits
    return formatter.format(this);
  }
}
