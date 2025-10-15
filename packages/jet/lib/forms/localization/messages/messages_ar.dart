import 'package:intl/intl.dart';
import 'messages.dart';

/// Arabic (ar) messages for Jet Form validators.
class JetFormMessagesAr extends JetFormMessages {
  const JetFormMessagesAr();

  @override
  String get requiredErrorText => 'هذا الحقل مطلوب.';

  @override
  String get emailErrorText => 'هذا الحقل يتطلب عنوان بريد إلكتروني صالح.';

  @override
  String get urlErrorText => 'هذا الحقل يتطلب عنوان URL صالح.';

  @override
  String get phoneErrorText => 'هذا الحقل يتطلب رقم هاتف صالح.';

  @override
  String get numericErrorText => 'يجب أن تكون القيمة رقمية.';

  @override
  String get integerErrorText => 'هذا الحقل يتطلب عددًا صحيحًا صالحًا.';

  @override
  String get creditCardErrorText => 'هذا الحقل يتطلب رقم بطاقة ائتمان صالح.';

  @override
  String get dateStringErrorText => 'هذا الحقل يتطلب تاريخًا صالحًا.';

  @override
  String equalErrorText(String value) => 'يجب أن تكون قيمة هذا الحقل مساوية لـ $value.';

  @override
  String notEqualErrorText(String value) => 'يجب ألا تكون قيمة هذا الحقل مساوية لـ $value.';

  @override
  String minLengthErrorText(int minLength) => 'يجب أن يكون الطول أكبر من أو يساوي $minLength.';

  @override
  String maxLengthErrorText(int maxLength) => 'يجب أن يكون الطول أقل من أو يساوي $maxLength.';

  @override
  String equalLengthErrorText(int length) => 'يجب أن يكون الطول مساويًا لـ $length.';

  @override
  String minErrorText(num min) => 'يجب أن تكون القيمة أكبر من أو تساوي $min.';

  @override
  String maxErrorText(num max) => 'يجب أن تكون القيمة أقل من أو تساوي $max.';

  @override
  String betweenErrorText(num min, num max) => 'يجب أن تكون القيمة بين $min و $max.';

  @override
  String get matchErrorText => 'القيمة لا تتطابق مع النمط.';

  @override
  String get uppercaseErrorText => 'يجب أن تكون القيمة بأحرف كبيرة.';

  @override
  String get lowercaseErrorText => 'يجب أن تكون القيمة بأحرف صغيرة.';

  @override
  String get alphabeticalErrorText => 'يجب أن تكون القيمة أبجدية.';

  @override
  String containsErrorText(String value) => 'يجب أن تحتوي القيمة على $value.';

  @override
  String startsWithErrorText(String value) => 'يجب أن تبدأ القيمة بـ $value.';

  @override
  String endsWithErrorText(String value) => 'يجب أن تنتهي القيمة بـ $value.';

  @override
  String containsSpecialCharErrorText(int min) => 'يجب أن تحتوي القيمة على $min أحرف خاصة على الأقل.';

  @override
  String containsUppercaseCharErrorText(int min) => 'يجب أن تحتوي القيمة على $min أحرف كبيرة على الأقل.';

  @override
  String containsLowercaseCharErrorText(int min) => 'يجب أن تحتوي القيمة على $min أحرف صغيرة على الأقل.';

  @override
  String containsNumberErrorText(int min) => 'يجب أن تحتوي القيمة على $min أرقام على الأقل.';

  @override
  String get mustBeTrueErrorText => 'يجب أن يكون هذا الحقل صحيحًا.';

  @override
  String get mustBeFalseErrorText => 'يجب أن يكون هذا الحقل خاطئًا.';

  @override
  String get ipErrorText => 'هذا الحقل يتطلب عنوان IP صالح.';

  @override
  String get latitudeErrorText => 'يجب أن تكون القيمة خط عرض صالح.';

  @override
  String get longitudeErrorText => 'يجب أن تكون القيمة خط طول صالح.';

  @override
  String get base64ErrorText => 'يجب أن تكون القيمة نص base64 صالح.';

  @override
  String get pathErrorText => 'يجب أن تكون القيمة مسارًا صالحًا.';

  @override
  String get oddNumberErrorText => 'يجب أن تكون القيمة رقمًا فرديًا.';

  @override
  String get evenNumberErrorText => 'يجب أن تكون القيمة رقمًا زوجيًا.';

  @override
  String get positiveNumberErrorText => 'يجب أن تكون القيمة رقمًا موجبًا.';

  @override
  String get negativeNumberErrorText => 'يجب أن تكون القيمة رقمًا سالبًا.';

  @override
  String get notZeroNumberErrorText => 'يجب ألا تكون القيمة صفرًا.';

  @override
  String portNumberErrorText(int min, int max) => 'يجب أن تكون القيمة رقم منفذ صالح بين $min و $max.';

  @override
  String get macAddressErrorText => 'يجب أن تكون القيمة عنوان MAC صالح.';

  @override
  String get uuidErrorText => 'يجب أن تكون القيمة UUID صالح.';

  @override
  String get jsonErrorText => 'يجب أن تكون القيمة JSON صالح.';

  @override
  String colorCodeErrorText(String colorCode) => 'يجب أن تكون القيمة رمز لون $colorCode صالح.';

  @override
  String get singleLineErrorText => 'يجب أن تكون القيمة سطرًا واحدًا.';

  @override
  String get timeErrorText => 'يجب أن تكون القيمة وقتًا صالحًا.';

  @override
  String get dateMustBeInTheFutureErrorText => 'يجب أن يكون التاريخ في المستقبل.';

  @override
  String get dateMustBeInThePastErrorText => 'يجب أن يكون التاريخ في الماضي.';

  @override
  String dateRangeErrorText(DateTime min, DateTime max) {
    final formatter = DateFormat.yMd('ar');
    return 'يجب أن يكون التاريخ في النطاق ${formatter.format(min)} - ${formatter.format(max)}.';
  }

  @override
  String fileExtensionErrorText(String extensions) => 'يجب أن يكون امتداد الملف $extensions.';

  @override
  String fileSizeErrorText(String maxSize, String fileSize) => 'يجب أن يكون حجم الملف أقل من $maxSize بينما هو $fileSize.';

  @override
  String get fileNameErrorText => 'يجب أن تكون القيمة اسم ملف صالح.';

  @override
  String get creditCardCVCErrorText => 'هذا الحقل يتطلب رمز CVC صالح.';

  @override
  String get creditCardExpirationDateErrorText => 'هذا الحقل يتطلب تاريخ انتهاء صالح.';

  @override
  String get creditCardExpiredErrorText => 'انتهت صلاحية بطاقة الائتمان هذه.';

  @override
  String get ibanErrorText => 'يجب أن تكون القيمة IBAN صالح.';

  @override
  String get bicErrorText => 'يجب أن تكون القيمة BIC صالح.';

  @override
  String get ssnErrorText => 'يجب أن تكون القيمة رقم ضمان اجتماعي صالح.';

  @override
  String get zipCodeErrorText => 'يجب أن تكون القيمة رمز بريدي صالح.';

  @override
  String get usernameErrorText => 'يجب أن تكون القيمة اسم مستخدم صالح.';

  @override
  String get passportNumberErrorText => 'يجب أن تكون القيمة رقم جواز سفر صالح.';

  @override
  String get cityErrorText => 'يجب أن تكون القيمة اسم مدينة صالح.';

  @override
  String get countryErrorText => 'يجب أن تكون القيمة بلدًا صالحًا.';

  @override
  String get stateErrorText => 'يجب أن تكون القيمة ولاية صالحة.';

  @override
  String get streetErrorText => 'يجب أن تكون القيمة اسم شارع صالح.';

  @override
  String get firstNameErrorText => 'يجب أن تكون القيمة اسمًا أول صالحًا.';

  @override
  String get lastNameErrorText => 'يجب أن تكون القيمة اسمًا أخيرًا صالحًا.';

  @override
  String get primeNumberErrorText => 'يجب أن تكون القيمة رقمًا أوليًا.';

  @override
  String get dunsErrorText => 'يجب أن تكون القيمة رقم DUNS صالح.';

  @override
  String get licensePlateErrorText => 'يجب أن تكون القيمة لوحة ترخيص صالحة.';

  @override
  String get vinErrorText => 'يجب أن تكون القيمة VIN صالح.';

  @override
  String get languageCodeErrorText => 'يجب أن تكون القيمة رمز لغة صالح.';

  @override
  String get floatErrorText => 'يجب أن تكون القيمة رقم عشري صالح.';

  @override
  String get hexadecimalErrorText => 'يجب أن تكون القيمة رقمًا سداسي عشري صالح.';

  @override
  String get isbnErrorText => 'يجب أن تكون القيمة ISBN صالح.';

  @override
  String get timezoneErrorText => 'يجب أن تكون القيمة منطقة زمنية صالحة.';

  @override
  String get invalidMimeTypeErrorText => 'نوع MIME غير صالح.';

  @override
  String get containsElementErrorText => 'يجب أن تكون القيمة في القائمة.';

  @override
  String get uniqueErrorText => 'يجب أن تكون القيمة فريدة.';

  @override
  String minWordsCountErrorText(int minWordsCount) => 'يجب أن يكون عدد الكلمات أكبر من أو يساوي $minWordsCount.';

  @override
  String maxWordsCountErrorText(int maxWordsCount) => 'يجب أن يكون عدد الكلمات أقل من أو يساوي $maxWordsCount.';
}

