import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget pdfHeader({
  required pw.Font regular,
  required pw.Font bold,
  required String title,
}) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(16),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'FinanceHub',
          style: pw.TextStyle(
            font: bold,
            fontSize: 24,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          title,
          style: pw.TextStyle(
            font: bold,
            fontSize: 18,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated: ${DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.now())}',
          style: pw.TextStyle(font: regular),
        ),
      ],
    ),
  );
}