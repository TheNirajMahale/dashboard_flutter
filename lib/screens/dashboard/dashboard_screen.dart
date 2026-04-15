import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<DashboardProvider>(context);
    const primaryTheme = Color(0xFF1A237E); // Deep Mining Navy

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9),
        appBar: AppBar(
          backgroundColor: primaryTheme,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text("Vela Mining Analytics"),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "OVERVIEW"),
              Tab(text: "HAULERS"),
              Tab(text: "ROUTES"),
              Tab(text: "INSIGHTS"),
            ],
          ),
        ),
        body: p.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOverview(p, primaryTheme),
                  _buildHaulerList(p),
                  _buildRouteVersus(p),
                  _buildInsights(p),
                ],
              ),
      ),
    );
  }

  // --- Tab 1: Overview with Bar Chart Visualization ---
  Widget _buildOverview(DashboardProvider p, Color theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader("Fleet Performance (KPIs)"),
        LayoutBuilder(
          builder: (context, constraints) {
            int count = constraints.maxWidth > 600 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _kpiCard(
                  "Total Fuel",
                  p.summary.totalFuel,
                  Icons.gas_meter,
                  Colors.orange,
                ),
                _kpiCard(
                  "Distance",
                  p.summary.totalDistance,
                  Icons.straighten,
                  Colors.blue,
                ),
                _kpiCard(
                  "Efficiency",
                  p.summary.efficiency,
                  Icons.trending_up,
                  Colors.red,
                ),
                _kpiCard(
                  "Trips",
                  p.summary.totalTrips,
                  Icons.assignment_turned_in,
                  Colors.green,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 30),
        _sectionHeader("Fuel Consumption by Hauler"),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              barGroups: p.haulers
                  .asMap()
                  .entries
                  .map(
                    (e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.fuel,
                          color: theme,
                          width: 22,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) => Text(
                      p.haulers[v.toInt()].id,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }
  // --- TAB 2: HAULER ANALYSIS with Conditional Formatting ---
  // This section replicates the "Hauler Performance" and "Operational Insights"

  Widget _buildHaulerList(DashboardProvider p) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: p.haulers.length,
      itemBuilder: (context, i) {
        final h = p.haulers[i];
        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            // REMOVED 'side' parameter to fix the error
            // Using shapes to prevent the black/rectangular border flicker
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            leading: CircleAvatar(
              backgroundColor: h.statusColor.withOpacity(0.1),
              child: Text(
                h.id,
                style: TextStyle(
                  color: h.statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text("Fuel: ${h.fuel} L | Speed: ${h.avgSpeed} km/h"),
            subtitle: Text(
              "${h.idlePercent}% Idle Time",
              style: TextStyle(
                color: h.statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Manager Insight: ${h.recommendation}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Tab 3: Route Comparison Versus UI ---
  Widget _buildRouteVersus(DashboardProvider p) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: p.comparisons.length,
      itemBuilder: (context, i) {
        final c = p.comparisons[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.metric.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _comparisonBox("GENTLE", c.gentle, Colors.green),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  _comparisonBox("STEEP", c.steep, Colors.red),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Tab 4: Savings & Bottlenecks ---
  Widget _buildInsights(DashboardProvider p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader("Potential Optimization Savings"),
        ...p.benefits.map(
          (b) => Card(
            color: b.metric.contains("year") ? Colors.green.shade50 : null,
            child: ListTile(
              title: Text(b.metric, style: const TextStyle(fontSize: 14)),
              trailing: Text(
                b.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionHeader("Terrain Bottlenecks (Top Penalties)"),
        ...p.penalties.map(
          (rp) => Card(
            child: ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade400,
              ),
              title: Text("Ramp ID ${rp.rampId} (Hauler ${rp.hauler})"),
              subtitle: Text("Pitch: ${rp.pitch}°"),
              trailing: Text(
                "+${rp.extraFuel}L",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Components ---
  Widget _comparisonBox(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    ),
  );

  Widget _kpiCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
          ),
          Text(
            val,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
    ),
  );
}
