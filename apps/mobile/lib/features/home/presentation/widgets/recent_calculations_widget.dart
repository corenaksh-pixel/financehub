import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/history/data/history_repository.dart';
import 'package:financehub/features/history/presentation/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentCalculationsWidget extends StatefulWidget {
  const RecentCalculationsWidget({super.key});

  @override
  State<RecentCalculationsWidget> createState() =>
      _RecentCalculationsWidgetState();
}

class _RecentCalculationsWidgetState
    extends State<RecentCalculationsWidget> {
  @override
  void initState() {
    super.initState();
    HistoryRepository.refresh.addListener(_reload);
  }

  @override
  void dispose() {
    HistoryRepository.refresh.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = HistoryService.getAll();

    if (history.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.history),
          title: Text('No calculations yet'),
          subtitle: Text('Your recent calculations will appear here.'),
        ),
      );
    }

    // HistoryRepository.getAll() already returns newest first
    final recent = history.take(3).toList();

    return Column(
      children: recent.map((item) {
        final firstResult = item.results.entries.first;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(item.calculator.substring(0, 1)),
              ),
              title: Text(item.calculator),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${firstResult.key}: ${firstResult.value}'),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(item.createdAt),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
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
      }).toList(),
    );
  }
}