import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/history_provider.dart';
import 'package:intl/intl.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  IconData _getCalculatorIcon(String calculator) {
    switch (calculator.toLowerCase()) {
      case 'income tax':
        return Icons.receipt_long;

      case 'emi':
        return Icons.home_work;

      case 'gst':
        return Icons.calculate;

      case 'sip':
        return Icons.trending_up;

      case 'fd':
        return Icons.savings;

      case 'rd':
        return Icons.account_balance_wallet;

      case 'ppf':
        return Icons.account_balance;

      case 'loan':
        return Icons.request_quote;

      default:
        return Icons.history;
    }
  }

  Color _getCalculatorColor(String calculator) {
    switch (calculator.toLowerCase()) {
      case 'income tax':
        return Colors.indigo;

      case 'gst':
        return Colors.orange;

      case 'emi':
        return Colors.green;

      case 'sip':
        return Colors.purple;

      case 'fd':
        return Colors.amber;

      case 'rd':
        return Colors.teal;

      case 'ppf':
        return Colors.blue;

      case 'loan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          IconButton(
            tooltip: 'Clear History',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text(
                    'Are you sure you want to delete all calculation history?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(historyProvider.notifier).clear();
              }
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No calculations yet',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete History'),
                            content: const Text(
                              'Delete this calculation from history?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) async {
                    await ref
                        .read(historyProvider.notifier)
                        .deleteById(item.id);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('History deleted')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCalculatorColor(
                          item.calculator,
                        ).withValues(alpha: 0.15),
                        child: Icon(
                          _getCalculatorIcon(item.calculator),
                          color: _getCalculatorColor(item.calculator),
                        ),
                      ),
                      title: Text(
                        item.calculator,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.inputs.isNotEmpty)
                              Text(
                                '${item.inputs.keys.first}: ${item.inputs.values.first}',
                              ),

                            const SizedBox(height: 2),

                            if (item.results.isNotEmpty)
                              Text(
                                '${item.results.keys.last}: ${item.results.values.last}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                            const SizedBox(height: 6),

                            Text(
                              DateFormat(
                                'dd MMM yyyy • hh:mm a',
                              ).format(item.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryDetailScreen(item: item),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
