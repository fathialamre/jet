import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/src/fields/form_builder_checkbox.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../form_builder_tester.dart';

void main() {
  group('FormBuilderCheckbox -', () {
    testWidgets('Off/On/Off', (WidgetTester tester) async {
      const widgetName = 'cb1';
      final testWidget = FormBuilderCheckbox(
        name: widgetName,
        title: const Text('Checkbox 1'),
        initialValue: false,
      );
      final widgetFinder = find.byWidget(testWidget);

      await tester.pumpWidget(buildTestableFieldWidget(testWidget));

      expect(formSave(), isTrue);
      expect(formValue(widgetName), isFalse);
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      expect(formSave(), isTrue);
      expect(formValue(widgetName), isTrue);
      await tester.tap(widgetFinder);
      await tester.pumpAndSettle();
      expect(formSave(), isTrue);
      expect(formValue(widgetName), isFalse);
    });
    testWidgets('When press tab, field will be focused', (
      WidgetTester tester,
    ) async {
      const widgetName = 'cb1';
      final testWidget = FormBuilderCheckbox(
        name: widgetName,
        title: const Text('Checkbox 1'),
        initialValue: false,
      );
      final widgetFinder = find.byWidget(testWidget);

      await tester.pumpWidget(buildTestableFieldWidget(testWidget));
      final focusNode =
          formKey.currentState?.fields[widgetName]?.effectiveFocusNode;

      expect(formSave(), isTrue);
      expect(formValue(widgetName), isFalse);
      expect(Focus.of(tester.element(widgetFinder)).hasFocus, false);
      expect(focusNode?.hasFocus, false);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(Focus.of(tester.element(widgetFinder)).hasFocus, true);
      expect(focusNode?.hasFocus, true);
    });
  });
}
