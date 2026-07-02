import 'package:financehub/features/history/domain/history_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryItem item;

  const HistoryDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy • hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(item.calculator),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            formatter.format(item.createdAt),
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          Text(
            'Inputs',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ...item.inputs.entries.map(
            (entry) => ListTile(
              title: Text(entry.key),
              trailing: Text(entry.value.toString()),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Results',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ...item.results.entries.map(
            (entry) => ListTile(
              title: Text(entry.key),
              trailing: Text(entry.value.toString()),
            ),
          ),
        ],
      ),
    );
  }
}