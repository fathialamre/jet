// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get enterPhoneNumber => 'Entrez votre numéro de téléphone';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get loginToContinue => 'Connectez-vous pour continuer';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get enterName => 'Entrez votre nom';

  @override
  String get enterOtp => 'Entrez votre code OTP';

  @override
  String get enterPasswordConfirmation => 'Confirmez votre mot de passe';
}
