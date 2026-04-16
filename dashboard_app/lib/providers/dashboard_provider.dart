import 'package:flutter/material.dart';
import '../models/fleet_models.dart';
import '../services/data_service.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = true;
  FleetSummary summary = FleetSummary();
  List<HaulerDetail> haulers = [];
  List<RouteComparison> comparisons = [];
  List<RouteBenefit> benefits = [];
  List<RampPenalty> penalties = [];

  Future<void> loadDashboard() async {
    try {
      isLoading = true;
      notifyListeners();

      final rawData = await DataService.loadFleetData();
      final monthly = rawData['monthly'];
      final route = rawData['route'];

      // 1. Process Executive Summary [cite: 32, 33]
      final exec = monthly['Executive Summary'];
      summary = FleetSummary(
        totalFuel: exec[3]['Column2'] ?? "0",
        fuelCost: exec[3]['Column3'] ?? "0",
        totalDistance: exec[4]['Column2'] ?? "0",
        totalTrips: exec[5]['Column2'] ?? "0",
        efficiency: exec[6]['Column2'] ?? "0",
      );

      // 2. Process Hauler Performance & Insights [cite: 36]
      final perf = monthly['Hauler Performance'] as List;
      final insights = monthly['Operational Insights'] as List;

      haulers = perf.map<HaulerDetail>((p) {
        final id = p['Hauler ID'].toString();
        final ins = insights.firstWhere(
          (i) => i['Hauler ID'].toString() == id,
          orElse: () => {},
        );
        return HaulerDetail(
          id: id,
          distance: (p['Distance (km)'] ?? 0).toDouble(),
          fuel: (p['Fuel (L)'] ?? 0).toDouble(),
          trips: p['Trips'] ?? 0,
          avgSpeed: (p['Avg Speed (km/h)'] ?? 0).toDouble(),
          idlePercent: (ins['Idle %'] ?? 0).toDouble(),
          recommendation: ins['Recommendation'] ?? "No active alerts",
        );
      }).toList();

      // 3. Process Route Comparison Summary
      comparisons = (route['Route_Comparison'] as List).map<RouteComparison>((
        i,
      ) {
        return RouteComparison(
          metric: i['Metric'],
          gentle: i['Route A (Gentle)'],
          steep: i['Route B (Steep)'],
        );
      }).toList();

      // 4. Process Savings & Terrain Penalties (Advanced Metrics)
      benefits = (route['Route_Benefit_Quantification'] as List)
          .map<RouteBenefit>((i) {
            return RouteBenefit(metric: i['Metric'], value: i['Value']);
          })
          .toList();

      penalties = (route['Worst_Gradient_Penalty'] as List).map<RampPenalty>((
        i,
      ) {
        return RampPenalty(
          rank: i['Rank'],
          hauler: i['Hauler'].toString(),
          rampId: i['Ramp ID'].toString(),
          pitch: (i['Avg Pitch (°)'] ?? 0).toDouble(),
          extraFuel: (i['Extra Fuel (L)'] ?? 0).toDouble(),
        );
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Init Error: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
