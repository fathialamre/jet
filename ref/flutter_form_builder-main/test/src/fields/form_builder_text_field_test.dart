import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../form_builder_tester.dart';

void main() {
  group('FormBuilderTextField -', () {
    testWidgets('Hello Planet', (WidgetTester tester) async {
      const newTextValue = 'Hello 🪐';
      const textFieldName = 'text1';
      final testWidget = FormBuilderTextField(name: textFieldName);
      final widgetFinder = find.byWidget(testWidget);

      await tester.pumpWidget(buildTestableFieldWidget(testWidget));
      expect(formSave(), isTrue);
      expect(formValue(textFieldName), isNull);
      await tester.enterText(widgetFinder, newTextValue);
      expect(formSave(), isTrue);
      expect(formValue(textFieldName), equals(newTextValue));
      await tester.enterText(widgetFinder, '');
      expect(formSave(), isTrue);
      expect(formValue(textFieldName), isEmpty);
    });
    testWidgets(
      'without initialValue',
      (tester) => _testFormBuilderTextFieldWithInitialValue(tester),
    );
    testWidgets(
      'has initialValue on Field',
      (tester) => _testFormBuilderTextFieldWithInitialValue(
        tester,
        initialValueOnField: 'ok',
      ),
    );
    testWidgets(
      'has initialValue on Form',
      (tester) => _testFormBuilderTextFieldWithInitialValue(
        tester,
        initialValueOnForm: 'ok',
      ),
    );

    testWidgets(
      'triggers onTapOutside',
      (tester) => _testFormBuilderTextFieldOnTapOutsideCallback(tester),
    );
    testWidgets('When press tab, field will be focused', (
      WidgetTester tester,
    ) async {
      const widgetName = 'cb1';
      var testWidget = FormBuilderTextField(name: widgetName);
      final widgetFinder = find.byWidget(testWidget);

      await tester.pumpWidget(buildTestableFieldWidget(testWidget));
      final focusNode =
          formKey.currentState?.fields[widgetName]?.effectiveFocusNode;

      expect(formSave(), isTrue);
      expect(formValue(widgetName), isNull);
      expect(Focus.of(tester.element(widgetFinder)).hasFocus, false);
      expect(focusNode?.hasFocus, false);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(Focus.of(tester.element(widgetFinder)).hasFocus, true);
      expect(focusNode?.hasFocus, true);
    });
  });
}

Future<void> _testFormBuilderTextFieldWithInitialValue(
  WidgetTester tester, {
  String? initialValueOnField,
  String? initialValueOnForm,
}) async {
  int changedCount = 0;
  const newTextValue = 'Hello 🪐';
  const textFieldName = 'text1';

  var testWidget = FormBuilderTextField(
    name: textFieldName,
    initialValue: initialValueOnField,
    onChanged: (String? value) => changedCount++,
  );
  await tester.pumpWidget(
    buildTestableFieldWidget(
      testWidget,
      initialValue: {textFieldName: initialValueOnForm},
    ),
  );
  expect(formSave(), isTrue);
  expect(formValue(textFieldName), initialValueOnField ?? initialValueOnForm);
  expect(changedCount, 0);

  await tester.enterText(find.byWidget(testWidget), newTextValue);
  expect(formSave(), isTrue);
  expect(formValue(textFieldName), newTextValue);

  expect(changedCount, 1);
}

Future<void> _testFormBuilderTextFieldOnTapOutsideCallback(
  WidgetTester tester,
) async {
  const textFieldName = 'Hello 🪐';
  bool triggered = false;

  var testWidget = FormBuilderTextField(
    name: textFieldName,
    onTapOutside: (event) => triggered = true,
  );
  await tester.pumpWidget(buildTestableFieldWidget(testWidget));
  final textField = tester.firstWidget(find.byType(TextField)) as TextField;
  textField.onTapOutside?.call(const PointerDownEvent());
  expect(triggered, true);
}
