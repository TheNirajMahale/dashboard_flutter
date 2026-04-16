import 'package:flutter/material.dart';

// Represents the high-level fleet stats from the Executive Summary
class FleetSummary {
  final String totalFuel, fuelCost, totalDistance, totalTrips, efficiency;

  FleetSummary({
    this.totalFuel = "0",
    this.fuelCost = "0",
    this.totalDistance = "0",
    this.totalTrips = "0",
    this.efficiency = "0",
  });
}

// Combines Hauler Performance and Operational Insights for a complete vehicle profile
class HaulerDetail {
  final String id;
  final double distance, fuel, avgSpeed, idlePercent;
  final int trips;
  final String recommendation;

  HaulerDetail({
    required this.id,
    required this.distance,
    required this.fuel,
    required this.trips,
    required this.avgSpeed,
    required this.idlePercent,
    required this.recommendation,
  });

  // Business logic: High idle time (over 85%) is a critical warning
  Color get statusColor => idlePercent > 85 ? Colors.red : Colors.green;
}

// Handles the 'Versus' comparison data between Route A and Route B
class RouteComparison {
  final String metric, gentle, steep;
  RouteComparison({
    required this.metric,
    required this.gentle,
    required this.steep,
  });
}

// Maps the financial benefits of optimizing routes
class RouteBenefit {
  final String metric, value;
  RouteBenefit({required this.metric, required this.value});
}

// Tracks specific terrain bottlenecks and fuel penalties
class RampPenalty {
  final int rank;
  final String hauler, rampId;
  final double pitch, extraFuel;

  RampPenalty({
    required this.rank,
    required this.hauler,
    required this.rampId,
    required this.pitch,
    required this.extraFuel,
  });
}
