import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService._();

  static Future<void> share({
    required BuildContext context,
    required String title,
    required Map<String, String> data,
    String footer = 'Generated using FinanceHub',
  }) async {
    final buffer = StringBuffer();

    buffer.writeln(title);
    buffer.writeln();

    data.forEach((key, value) {
      buffer.writeln('$key: $value');
    });

    buffer.writeln();
    buffer.writeln(footer);

    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        sharePositionOrigin:
            box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}