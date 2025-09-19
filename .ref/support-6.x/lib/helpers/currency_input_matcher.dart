import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// Currency meta data
class CurrencyMeta {
  /// Currency symbol
  String symbol;

  /// Initial value
  String initialValue = "";

  /// Currency formatter
  CurrencyInputFormatter formatter;

  CurrencyMeta(
      {required this.symbol, required this.formatter, this.initialValue = ""});
}

/// Currency input matcher
class CurrencyInputMatcher {
  /// Get all supported currencies
  static List<String> currencies = [
    "gbp",
    "usd",
    "vnd",
    "thb",
    "twd",
    "eur",
    "myr",
    "jpy",
    "aud",
    "cny",
    "cad",
    "inr",
    "idr",
    "sgd",
    "zar",
    "pkr",
    "chf",
    "brl",
    "rub",
    "krw",
    "mxn",
    "hkd",
    "nzd",
    "sek",
    "aed",
    "dkk",
    "pln",
    "try",
    "ngn",
    "php",
    "egp",
    "ars",
    "clp",
    "cop",
    "pen",
    "uah",
    "ils",
    "czk",
    "nok",
    "bhd",
    "kwd",
    "qar",
    "sar",
    "ron",
    "hrk",
    "bgn",
    "huf",
    "mad",
    "isk",
    "kzt",
    "lkr",
    "mmk",
    "bdt",
    "kes",
    "tzs",
    "ugx",
    "rwf",
  ];

  /// Get the currency meta data
  static CurrencyMeta getCurrencyMeta(String castTo,
      {required String value, void Function(num? value)? onChanged}) {
    String defaultValue = "";
    String symbol = "";
    CurrencyInputFormatter? formatter;
    switch (castTo) {
      case "currency:gbp":
        symbol = "£";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:usd":
        symbol = "\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:vnd":
        symbol = "₫";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:thb":
        symbol = "฿";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:twd":
        symbol = "NT\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:eur":
        symbol = "€";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
            onValueChange: onChanged, trailingSymbol: " $symbol");
        break;
      case "currency:myr":
        symbol = "RM";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
            onValueChange: onChanged, leadingSymbol: symbol);
        break;
      case "currency:jpy":
        symbol = "¥";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:aud":
        symbol = "A\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:cny":
        symbol = "¥";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:cad":
        symbol = "CA\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:inr":
        symbol = "₹";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:idr":
        symbol = "Rp";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:sgd":
        symbol = "S\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:zar":
        symbol = "R";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:pkr":
        symbol = "Rs";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:chf":
        symbol = "CHF";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
      case "currency:brl":
        symbol = "R\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:rub":
        symbol = "₽";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:krw":
        symbol = "₩";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:mxn":
        symbol = "MX\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:hkd":
        symbol = "HK\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:nzd":
        symbol = "NZ\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:sek":
        symbol = "kr";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:aed":
        symbol = "د.إ";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:dkk":
        symbol = "kr";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:pln":
        symbol = "zł";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:try":
        symbol = "₺";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:ngn":
        symbol = "₦";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:php":
        symbol = "₱";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:egp":
        symbol = "E£";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:ars":
        symbol = "AR\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:clp":
        symbol = "CL\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:cop":
        symbol = "CO\$";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:pen":
        symbol = "S/";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:uah":
        symbol = "₴";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:ils":
        symbol = "₪";
        defaultValue = symbol + value;
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:czk":
        symbol = "Kč";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:nok":
        symbol = "kr";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:bhd":
        symbol = "BD";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:kwd":
        symbol = "KD";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:qar":
        symbol = "QR";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:sar":
        symbol = "SR";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:ron":
        symbol = "lei";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:hrk":
        symbol = "kn";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:bgn":
        symbol = "лв";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:huf":
        symbol = "Ft";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:mad":
        symbol = "DH";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:isk":
        symbol = "kr";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:kzt":
        symbol = "₸";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:lkr":
        symbol = "Rs";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
      case "currency:mmk":
        symbol = "K";
        defaultValue = "$value $symbol";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          trailingSymbol: " $symbol",
        );
        break;
      case "currency:bdt":
        symbol = "৳";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: symbol,
        );
        break;
      case "currency:kes":
        symbol = "KSh";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
      case "currency:tzs":
        symbol = "TSh";
        defaultValue = "$symbol $value";
        formatter = formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
      case "currency:ugx":
        symbol = "USh";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
      case "currency:rwf":
        symbol = "FRw";
        defaultValue = "$symbol $value";
        formatter = CurrencyInputFormatter(
          onValueChange: onChanged,
          leadingSymbol: "$symbol ",
        );
        break;
    }

    if (formatter == null) {
      throw Exception("Currency not supported");
    }

    return CurrencyMeta(
        symbol: symbol, formatter: formatter, initialValue: defaultValue);
  }
}
