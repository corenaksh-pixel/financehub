import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financehub/core/services/history_service.dart';
import 'package:financehub/features/calculators/domain/calculator_catalog.dart';
import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:financehub/features/home/domain/dashboard_stats.dart';

class DashboardNotifier extends Notifier<DashboardStats> {
  @override
  DashboardStats build() {
    return _createStats();
  }

  DashboardStats _createStats() {
    return DashboardStats(
      calculators: CalculatorCatalog.calculators.length,
      favorites: FavoritesRepository.getAll().length,
      recent: HistoryService.getAll().length,
    );
  }

  void refresh() {
    state = _createStats();
  }
}

final dashboardProvider =
    NotifierProvider<DashboardNotifier, DashboardStats>(
  DashboardNotifier.new,
);