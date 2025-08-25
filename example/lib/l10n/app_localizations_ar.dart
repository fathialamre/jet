// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get welcome => 'مرحبا بك ';

  @override
  String get loginToContinue => 'سجل دخولك للمتابعة';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get enterName => 'أدخل الاسم';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String get enterPasswordConfirmation => 'أدخل تأكيد كلمة المرور';
}
