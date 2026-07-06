import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  const PdfExportService();

  Future<File> save({
    required pw.Document document,
    required String fileName,
  }) async {
    final directory = await getTemporaryDirectory();

    final file = File(
      '${directory.path}/$fileName.pdf',
    );

    await file.writeAsBytes(
      await document.save(),
    );

    return file;
  }

  Future<void> printDocument(
    pw.Document document,
  ) async {
    await Printing.layoutPdf(
      onLayout: (_) async => document.save(),
    );
  }

  Future<void> shareDocument(
    pw.Document document,
  ) async {
    await Printing.sharePdf(
      bytes: await document.save(),
      filename: 'FinanceHub_Report.pdf',
    );
  }
}