import 'package:flutter/material.dart';
import 'dart:async';

enum JetButtonType {
  filled,
  outlined,
  text,
  elevated,
}

class JetButton extends StatefulWidget {
  const JetButton({
    super.key,
    required this.text,
    this.onTap,
    this.type = JetButtonType.filled,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.loadingText,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.isExpanded = false,
  });

  final String text;
  final FutureOr<void>? Function()? onTap;
  final JetButtonType type;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final String? loadingText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool isExpanded;

  // Static constructors for convenience
  static JetButton filled({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    bool isEnabled = true,
    double? width,
    double? height,
    bool isExpanded = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    String? loadingText,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return JetButton(
      key: key,
      text: text,
      onTap: onTap,
      type: JetButtonType.filled,
      isEnabled: isEnabled,
      width: width,
      height: height,
      isExpanded: isExpanded,
      icon: icon,
      iconPosition: iconPosition,
      loadingText: loadingText,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
    );
  }

  static JetButton outlined({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    bool isEnabled = true,
    double? width,
    double? height,
    bool isExpanded = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    String? loadingText,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return JetButton(
      key: key,
      text: text,
      onTap: onTap,
      type: JetButtonType.outlined,
      isEnabled: isEnabled,
      width: width,
      height: height,
      isExpanded: isExpanded,
      icon: icon,
      iconPosition: iconPosition,
      loadingText: loadingText,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
    );
  }

  static JetButton textButton({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    bool isEnabled = true,
    double? width,
    double? height,
    bool isExpanded = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    String? loadingText,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return JetButton(
      key: key,
      text: text,
      onTap: onTap,
      type: JetButtonType.text,
      isEnabled: isEnabled,
      width: width,
      height: height,
      isExpanded: isExpanded,
      icon: icon,
      iconPosition: iconPosition,
      loadingText: loadingText,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
    );
  }

  static JetButton elevated({
    Key? key,
    required String text,
    required FutureOr<void> Function() onTap,
    bool isEnabled = true,
    double? width,
    double? height,
    bool isExpanded = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    String? loadingText,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return JetButton(
      key: key,
      text: text,
      onTap: onTap,
      type: JetButtonType.elevated,
      isEnabled: isEnabled,
      width: width,
      height: height,
      isExpanded: isExpanded,
      icon: icon,
      iconPosition: iconPosition,
      loadingText: loadingText,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
    );
  }

  @override
  State<JetButton> createState() => _JetButtonState();
}

class _JetButtonState extends State<JetButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    final result = widget.onTap?.call();

    // Check if the result is a Future
    if (result is Future) {
      setState(() {
        _isLoading = true;
      });

      try {
        await result;
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    // If it's not a Future, it's already completed (synchronous)
  }

  Widget _buildButtonContent() {
    final displayText = _isLoading && widget.loadingText != null
        ? widget.loadingText!
        : widget.text;

    if (_isLoading) {
      return Row(
        mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          if (widget.loadingText != null) ...[
            const SizedBox(width: 8),
            Text(displayText),
          ],
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.iconPosition == IconPosition.left) ...[
            Icon(widget.icon),
            const SizedBox(width: 8),
            Text(displayText),
          ] else ...[
            Text(displayText),
            const SizedBox(width: 8),
            Icon(widget.icon),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(displayText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.isEnabled && !_isLoading;
    final onPressed = isEnabled ? _handleTap : null;

    final defaultPadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    Widget button;

    switch (widget.type) {
      case JetButtonType.filled:
        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            padding: defaultPadding,
            textStyle: widget.textStyle,
          ),
          child: _buildButtonContent(),
        );
        break;

      case JetButtonType.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            side: BorderSide(
              color: widget.borderColor ?? theme.colorScheme.outline,
            ),
            padding: defaultPadding,
            textStyle: widget.textStyle,
          ),
          child: _buildButtonContent(),
        );
        break;

      case JetButtonType.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            padding: defaultPadding,
            textStyle: widget.textStyle,
          ),
          child: _buildButtonContent(),
        );
        break;

      case JetButtonType.elevated:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,

            padding: defaultPadding,
            textStyle: widget.textStyle,
          ),
          child: _buildButtonContent(),
        );
        break;
    }

    if (widget.width != null || widget.height != null) {
      button = SizedBox(
        width: widget.width,
        height: widget.height,
        child: button,
      );
    }

    return button;
  }
}

enum IconPosition {
  left,
  right,
}
