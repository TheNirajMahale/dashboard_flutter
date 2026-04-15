import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  // IMPORTANT FOR NIRAJ:
  // If using Android Emulator, use "http://10.0.2.2:5000/api"
  // If using a real phone, use your PC's IP address (e.g., "http://192.168.1.5:5000/api")
  // If using Flutter Web/Desktop, use "http://localhost:5000/api"
  static const String baseUrl = "http://192.168.1.12:5000/api";

  static Future<Map<String, dynamic>> loadFleetData() async {
    try {
      // 1. Fetch Monthly Data
      final monthlyResponse = await http.get(Uri.parse('$baseUrl/monthly'));

      // 2. Fetch Route Data
      final routeResponse = await http.get(Uri.parse('$baseUrl/routes'));

      if (monthlyResponse.statusCode == 200 &&
          routeResponse.statusCode == 200) {
        return {
          'monthly': json.decode(monthlyResponse.body),
          'route': json.decode(routeResponse.body),
        };
      } else {
        throw Exception("Server returned error: ${monthlyResponse.statusCode}");
      }
    } catch (e) {
      // This will catch connection timeouts or "Connection Refused"
      print("Network Error: $e");
      throw Exception("Could not connect to Backend: $e");
    }
  }
}
