/*import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? token;

  ApiService({required this.baseUrl, this.token});

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(url, headers: _headers(), body: jsonEncode(data));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur POST $endpoint: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(url, headers: _headers(), body: jsonEncode(data));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur PUT $endpoint: ${response.statusCode}');
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url, headers: _headers());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur GET $endpoint: ${response.statusCode}');
  }
}

*/




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


