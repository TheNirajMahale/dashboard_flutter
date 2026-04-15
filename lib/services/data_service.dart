import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  // Loads both JSON files simultaneously from the local assets
  static Future<Map<String, dynamic>> loadFleetData() async {
    final String monthlyStr = await rootBundle.loadString(
      'lib/data/monthly.json',
    );
    final String routeStr = await rootBundle.loadString(
      'lib/data/Route_and_Fuel.json',
    );

    return {'monthly': json.decode(monthlyStr), 'route': json.decode(routeStr)};
  }
}
