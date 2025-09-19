import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';
import 'package:jet_flutter_framework/jet_framework.dart';
import 'package:jet_flutter_framework/resources/state/jet_consumer.dart';

class JetLoadingMoreWidget extends JetConsumerWidget {
  const JetLoadingMoreWidget({super.key, this.loader, this.text});

  final Widget? loader;
  final String? text;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
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
