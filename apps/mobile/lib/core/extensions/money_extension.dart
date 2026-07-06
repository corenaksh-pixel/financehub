import '../utils/currency_formatter.dart';

extension MoneyExtension on num {
  String get inr => CurrencyFormatter.format(this);
}