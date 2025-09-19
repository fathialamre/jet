import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';

class JetLoader extends StatelessWidget {
  const JetLoader({super.key, this.color, this.value});

  final Color? color;
  final double? value;

  @override
  Widget build(BuildContext context) {
    if (!context.isIOS) {
      return Center(
        child: CupertinoActivityIndicator(
          color: color,
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(
        color: color,
        value: value,
      ),
    );
  }
}
