import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class SharePdfService {
  static Future<void> share({
    required pw.Document pdf,
    required String fileName,
  }) async {
    final directory = await getTemporaryDirectory();

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final file = File('${directory.path}/$fileName.pdf');

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    await file.writeAsBytes(await pdf.save(), flush: true);

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> printPdf(pw.Document pdf) async {
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }
}
