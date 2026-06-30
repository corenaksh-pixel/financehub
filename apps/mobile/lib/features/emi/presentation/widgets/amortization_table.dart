import 'package:financehub/features/emi/domain/emi_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmortizationTable extends StatelessWidget {
  final List<EmiSchedule> schedule;

  const AmortizationTable({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 2,
    );

    return Card(
      elevation: 4,
      child: ExpansionTile(
        leading: const Icon(Icons.table_chart),
        title: const Text(
          "Amortization Schedule",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${schedule.length} Monthly Payments"),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              columns: const [
                DataColumn(label: Text("Month")),
                DataColumn(label: Text("EMI")),
                DataColumn(label: Text("Principal")),
                DataColumn(label: Text("Interest")),
                DataColumn(label: Text("Balance")),
              ],
              rows: schedule.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.month.toString())),
                    DataCell(Text(formatter.format(item.emi))),
                    DataCell(Text(formatter.format(item.principal))),
                    DataCell(Text(formatter.format(item.interest))),
                    DataCell(Text(formatter.format(item.balance))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}