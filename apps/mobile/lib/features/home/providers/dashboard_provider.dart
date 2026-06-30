import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStats {
  final int calculators;
  final int favorites;
  final int recent;

  const DashboardStats({
    required this.calculators,
    required this.favorites,
    required this.recent,
  });
}

final dashboardProvider = Provider<DashboardStats>((ref) {
  return const DashboardStats(
    calculators: 24,
    favorites: 6,
    recent: 12,
  );
});