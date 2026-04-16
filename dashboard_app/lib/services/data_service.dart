import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  // Back to localhost for ADB Reverse stability
  static const String baseUrl = "http://localhost:5000/api";

  static Future<Map<String, dynamic>> loadFleetData() async {
    try {
      final monthlyRes = await http.get(Uri.parse('$baseUrl/monthly'));
      final routeRes = await http.get(Uri.parse('$baseUrl/routes'));

      if (monthlyRes.statusCode == 200 && routeRes.statusCode == 200) {
        return {
          'monthly': json.decode(monthlyRes.body),
          'route': json.decode(routeRes.body),
        };
      } else {
        throw Exception("Server Error: ${monthlyRes.statusCode}");
      }
    } catch (e) {
      print("Connection Error: $e");
      throw Exception("Check if ADB reverse is active and server is running.");
    }
  }
}
