import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/history/domain/history_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'history_detail_screen.dart';
import 'package:financehub/shared/widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() {
    setState(() {
      history = HistoryService.getAll();
    });
  }

  Future<void> clearHistory() async {
    await HistoryService.clear();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy • hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: history.isEmpty ? null : clearHistory,
          ),
        ],
      ),
      body: history.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'No History Yet',
              subtitle: 'Your calculations will appear here.',
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calculate),
                    title: Text(item.calculator),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatter.format(item.createdAt)),
                        const SizedBox(height: 4),
                        ...item.results.entries
                            .take(2)
                            .map(
                              (entry) => Text(
                                '${entry.key}: ${entry.value}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                      ],
                    ),
                    onTap: () {
                      print("History tapped");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistoryDetailScreen(item: item),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await HistoryService.delete(index);
                        loadHistory();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
