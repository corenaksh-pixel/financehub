import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter =
      NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );

  static String format(num value) {
    return _formatter.format(value);
  }
}