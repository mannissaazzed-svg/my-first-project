

/*
class ApiService {
  String? token; 

  
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    return {};
  }


  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    return {};
  }

  
  Future<dynamic> get(String endpoint) async {
    return {};
  }

 
}
*/




import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  String? token;

  final baseUrl = "http://localhost:8000";

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": token != null ? "Bearer $token" : "",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": token != null ? "Bearer $token" : "",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Authorization": token != null ? "Bearer $token" : "",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }
}











