import 'package:flutter/cupertino.dart';
import 'dart:async';

class JetCupertinoButton extends StatefulWidget {
  const JetCupertinoButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.loadingText,
    this.textStyle,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  final String text;
  final FutureOr<void> Function() onTap;
  final bool isEnabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final String? loadingText;
  final TextStyle? textStyle;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  @override
  State<JetCupertinoButton> createState() => _JetCupertinoButtonState();
}

class _JetCupertinoButtonState extends State<JetCupertinoButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    final result = widget.onTap();

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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(
            radius: 8,
          ),
          if (widget.loadingText != null) ...[
            const SizedBox(width: 8),
            Text(
              displayText,
              style: widget.textStyle,
            ),
          ],
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.iconPosition == IconPosition.left) ...[
            Icon(widget.icon, size: 16),
            const SizedBox(width: 8),
            Text(
              displayText,
              style: widget.textStyle,
            ),
          ] else ...[
            Text(
              displayText,
              style: widget.textStyle,
            ),
            const SizedBox(width: 8),
            Icon(widget.icon, size: 16),
          ],
        ],
      );
    }

    return Text(
      displayText,
      style: widget.textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.isEnabled && !_isLoading;
    final onPressed = isEnabled ? _handleTap : null;

    return CupertinoDialogAction(
      onPressed: onPressed,
      isDefaultAction: widget.isDefaultAction,
      isDestructiveAction: widget.isDestructiveAction,
      textStyle: widget.textStyle,
      child: _buildButtonContent(),
    );
  }
}

enum IconPosition {
  left,
  right,
}
