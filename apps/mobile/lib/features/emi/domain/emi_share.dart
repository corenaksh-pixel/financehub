import 'package:share_plus/share_plus.dart';

class EmiShare {
  static Future<void> share({
    required String emi,
    required String interest,
    required String payment,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            '''
🏦 FinanceHub EMI Calculation

Monthly EMI: $emi

Total Interest: $interest

Total Payment: $payment

Generated using FinanceHub
''',
      ),
    );
  }
}
