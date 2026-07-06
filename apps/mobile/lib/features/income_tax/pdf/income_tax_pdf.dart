import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

import '../../../core/pdf/pdf_footer.dart';
import '../../../core/pdf/pdf_header.dart';
import '../domain/tax_result.dart';

class IncomeTaxPdf {
  static Future<pw.Document> build({required TaxResult result}) async {
    final pdf = pw.Document();

    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );

    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 2,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (_) => [
          pdfHeader(regular: regular, bold: bold, title: 'Income Tax Report'),

          pw.SizedBox(height: 20),

          pw.Header(
            level: 1,
            child: pw.Text('Income Summary', style: pw.TextStyle(font: bold)),
          ),

          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: bold),

            cellStyle: pw.TextStyle(font: regular),
            headers: ['Particular', 'Value'],
            data: [
              ['Gross Income', formatter.format(result.grossIncome)],
              [
                'Standard Deduction',
                formatter.format(result.standardDeduction),
              ],
              ['Taxable Income', formatter.format(result.taxableIncome)],
              ['Slab Tax', formatter.format(result.slabTax)],
              ['Rebate', formatter.format(result.rebate)],
              ['Cess', formatter.format(result.cess)],
              ['Total Tax', formatter.format(result.totalTax)],
              ['Annual Take Home', formatter.format(result.takeHome)],
              ['Monthly Tax', formatter.format(result.monthlyTax)],
              ['Monthly Take Home', formatter.format(result.takeHome / 12)],
              [
                'Effective Tax Rate',
                '${result.effectiveTaxRate.toStringAsFixed(2)}%',
              ],
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Header(
            level: 1,
            child: pw.Text('Tax Breakdown', style: pw.TextStyle(font: bold)),
          ),

          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: bold),

            cellStyle: pw.TextStyle(font: regular),
            headers: ['Slab', 'Rate', 'Taxable', 'Tax'],
            data: result.breakdown
                .map(
                  (e) => [
                    e.slab,
                    '${(e.rate * 100).toStringAsFixed(0)}%',
                    formatter.format(e.taxableAmount),
                    formatter.format(e.tax),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 30),

          pdfFooter(regular: regular, bold: bold),
        ],
      ),
    );

    return pdf;
  }
}
