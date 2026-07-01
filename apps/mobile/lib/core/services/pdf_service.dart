import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  const PdfService._();

  static Future<void> generateReport({
    required String title,
    required Map<String, String> data,
    String footer = 'Generated using FinanceHub',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Table(
            border: pw.TableBorder.all(),
            children: data.entries
                .map(
                  (entry) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          entry.key,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(entry.value),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),

          pw.SizedBox(height: 24),

          pw.Text(
            footer,
            style: const pw.TextStyle(
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }
}