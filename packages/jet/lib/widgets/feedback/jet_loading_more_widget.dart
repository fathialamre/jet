import 'package:flutter/material.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet_framework.dart';

class JetLoadingMoreWidget extends JetConsumerWidget {
  const JetLoadingMoreWidget({super.key, this.loader, this.text});

  final Widget? loader;
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref, Jet jet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        spacing: 8,
        children: [
          loader ?? jet.config.loader,
          Text(text ?? context.jetI10n.loadingMore),
        ],
      ),
    );
  }
}
