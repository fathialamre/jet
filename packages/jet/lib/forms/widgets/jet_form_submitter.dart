import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/forms/common.dart';
import 'package:jet/forms/notifiers/jet_form_notifier.dart';

class JetFormSubmitter<Request, Response> extends ConsumerWidget {
  const JetFormSubmitter({
    super.key,
    required this.provider,
    required this.builder,
  });
  final JetFormProvider<Request, Response> provider;
  final Function(
    BuildContext context,
    WidgetRef ref,
    JetForm<Request, Response> form,
    AsyncFormValue<Request, Response> formState,
  )
  builder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(provider);
    final form = ref.read(provider.notifier);
    return builder(context, ref, form, formState);
  }
}
