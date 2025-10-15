import 'package:intl/intl.dart';
import 'messages.dart';

/// French (fr) messages for Jet Form validators.
class JetFormMessagesFr extends JetFormMessages {
  const JetFormMessagesFr();

  @override
  String get requiredErrorText => 'Ce champ ne peut pas être vide.';

  @override
  String get emailErrorText => 'Ce champ nécessite une adresse e-mail valide.';

  @override
  String get urlErrorText => 'Ce champ nécessite une adresse URL valide.';

  @override
  String get phoneErrorText =>
      'Ce champ nécessite un numéro de téléphone valide.';

  @override
  String get numericErrorText => 'La valeur doit être numérique.';

  @override
  String get integerErrorText => 'Ce champ nécessite un entier valide.';

  @override
  String get creditCardErrorText =>
      'Ce champ nécessite un numéro de carte de crédit valide.';

  @override
  String get dateStringErrorText => 'Ce champ nécessite une date valide.';

  @override
  String equalErrorText(String value) =>
      'La valeur de ce champ doit être égale à $value.';

  @override
  String notEqualErrorText(String value) =>
      'La valeur de ce champ ne doit pas être égale à $value.';

  @override
  String minLengthErrorText(int minLength) =>
      'La valeur doit avoir une longueur supérieure ou égale à $minLength.';

  @override
  String maxLengthErrorText(int maxLength) =>
      'La valeur doit avoir une longueur inférieure ou égale à $maxLength.';

  @override
  String equalLengthErrorText(int length) =>
      'La valeur doit avoir une longueur égale à $length.';

  @override
  String minErrorText(num min) =>
      'La valeur doit être supérieure ou égale à $min.';

  @override
  String maxErrorText(num max) =>
      'La valeur doit être inférieure ou égale à $max.';

  @override
  String betweenErrorText(num min, num max) =>
      'La valeur doit être entre $min et $max.';

  @override
  String get matchErrorText => 'La valeur ne correspond pas au modèle.';

  @override
  String get uppercaseErrorText => 'La valeur doit être en majuscules.';

  @override
  String get lowercaseErrorText => 'La valeur doit être en minuscules.';

  @override
  String get alphabeticalErrorText => 'La valeur doit être alphabétique.';

  @override
  String containsErrorText(String value) => 'La valeur doit contenir $value.';

  @override
  String startsWithErrorText(String value) =>
      'La valeur doit commencer par $value.';

  @override
  String endsWithErrorText(String value) =>
      'La valeur doit se terminer par $value.';

  @override
  String containsSpecialCharErrorText(int min) =>
      'La valeur doit contenir au moins $min caractères spéciaux.';

  @override
  String containsUppercaseCharErrorText(int min) =>
      'La valeur doit contenir au moins $min majuscules.';

  @override
  String containsLowercaseCharErrorText(int min) =>
      'La valeur doit contenir au moins $min minuscules.';

  @override
  String containsNumberErrorText(int min) =>
      'La valeur doit contenir au moins $min chiffres.';

  @override
  String get mustBeTrueErrorText => 'Ce champ doit être vrai.';

  @override
  String get mustBeFalseErrorText => 'Ce champ doit être faux.';

  @override
  String get ipErrorText => 'Ce champ nécessite une adresse IP valide.';

  @override
  String get latitudeErrorText => 'La valeur doit être une latitude valide.';

  @override
  String get longitudeErrorText => 'La valeur doit être une longitude valide.';

  @override
  String get base64ErrorText => 'La valeur doit être une chaîne base64 valide.';

  @override
  String get pathErrorText => 'La valeur doit être un chemin valide.';

  @override
  String get oddNumberErrorText => 'La valeur doit être un nombre impair.';

  @override
  String get evenNumberErrorText => 'La valeur doit être un nombre pair.';

  @override
  String get positiveNumberErrorText =>
      'La valeur doit être un nombre positif.';

  @override
  String get negativeNumberErrorText =>
      'La valeur doit être un nombre négatif.';

  @override
  String get notZeroNumberErrorText => 'La valeur ne doit pas être zéro.';

  @override
  String portNumberErrorText(int min, int max) =>
      'La valeur doit être un numéro de port valide entre $min et $max.';

  @override
  String get macAddressErrorText =>
      'La valeur doit être une adresse MAC valide.';

  @override
  String get uuidErrorText => 'La valeur doit être un UUID valide.';

  @override
  String get jsonErrorText => 'La valeur doit être un JSON valide.';

  @override
  String colorCodeErrorText(String colorCode) =>
      'La valeur doit être un code couleur $colorCode valide.';

  @override
  String get singleLineErrorText => 'La valeur doit être une seule ligne.';

  @override
  String get timeErrorText => 'La valeur doit être une heure valide.';

  @override
  String get dateMustBeInTheFutureErrorText =>
      'La date doit être dans le futur.';

  @override
  String get dateMustBeInThePastErrorText => 'La date doit être dans le passé.';

  @override
  String dateRangeErrorText(DateTime min, DateTime max) {
    final formatter = DateFormat.yMd('fr');
    return 'La date doit être dans la plage ${formatter.format(min)} - ${formatter.format(max)}.';
  }

  @override
  String fileExtensionErrorText(String extensions) =>
      'L\'extension du fichier doit être $extensions.';

  @override
  String fileSizeErrorText(String maxSize, String fileSize) =>
      'La taille du fichier doit être inférieure à $maxSize alors qu\'elle est de $fileSize.';

  @override
  String get fileNameErrorText =>
      'La valeur doit être un nom de fichier valide.';

  @override
  String get creditCardCVCErrorText => 'Ce champ nécessite un code CVC valide.';

  @override
  String get creditCardExpirationDateErrorText =>
      'Ce champ nécessite une date d\'expiration valide.';

  @override
  String get creditCardExpiredErrorText => 'Cette carte de crédit a expiré.';

  @override
  String get ibanErrorText => 'La valeur doit être un IBAN valide.';

  @override
  String get bicErrorText => 'La valeur doit être un BIC valide.';

  @override
  String get ssnErrorText =>
      'La valeur doit être un numéro de sécurité sociale valide.';

  @override
  String get zipCodeErrorText => 'La valeur doit être un code postal valide.';

  @override
  String get usernameErrorText =>
      'La valeur doit être un nom d\'utilisateur valide.';

  @override
  String get passportNumberErrorText =>
      'La valeur doit être un numéro de passeport valide.';

  @override
  String get cityErrorText => 'La valeur doit être un nom de ville valide.';

  @override
  String get countryErrorText => 'La valeur doit être un pays valide.';

  @override
  String get stateErrorText => 'La valeur doit être un état valide.';

  @override
  String get streetErrorText => 'La valeur doit être un nom de rue valide.';

  @override
  String get firstNameErrorText => 'La valeur doit être un prénom valide.';

  @override
  String get lastNameErrorText =>
      'La valeur doit être un nom de famille valide.';

  @override
  String get primeNumberErrorText => 'La valeur doit être un nombre premier.';

  @override
  String get dunsErrorText => 'La valeur doit être un numéro DUNS valide.';

  @override
  String get licensePlateErrorText =>
      'La valeur doit être une plaque d\'immatriculation valide.';

  @override
  String get vinErrorText => 'La valeur doit être un VIN valide.';

  @override
  String get languageCodeErrorText =>
      'La valeur doit être un code de langue valide.';

  @override
  String get floatErrorText =>
      'La valeur doit être un nombre à virgule flottante valide.';

  @override
  String get hexadecimalErrorText =>
      'La valeur doit être un nombre hexadécimal valide.';

  @override
  String get isbnErrorText => 'La valeur doit être un ISBN valide.';

  @override
  String get timezoneErrorText =>
      'La valeur doit être un fuseau horaire valide.';

  @override
  String get invalidMimeTypeErrorText => 'Type MIME invalide.';

  @override
  String get containsElementErrorText => 'La valeur doit être dans la liste.';

  @override
  String get uniqueErrorText => 'La valeur doit être unique.';

  @override
  String minWordsCountErrorText(int minWordsCount) =>
      'La valeur doit avoir un nombre de mots supérieur ou égal à $minWordsCount.';

  @override
  String maxWordsCountErrorText(int maxWordsCount) =>
      'La valeur doit avoir un nombre de mots inférieur ou égal à $maxWordsCount.';
}
