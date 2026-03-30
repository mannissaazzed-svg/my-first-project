import 'package:mobi_relex/services/api_service.dart';
import 'mock_data.dart';
import 'package:mockito/mockito.dart';

class MockApiService extends Mock implements ApiService {

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    if (endpoint == "auth/login") {
      if (data["compte"] == "test@mail.com" && data["password"] == "1234") {
        return MockData.loginSuccess;
      } else {
        return MockData.loginFail;
      }
    }
    return {"success": false};
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    return {"success": true}; // Approve/Rejeter toujours succès
  }

  @override
  Future<dynamic> get(String endpoint) async {
    if (endpoint.contains("demandes/en-attente")) return MockData.missions;
    if (endpoint.contains("droits/mes-profils")) return MockData.supervisorsList;
    return {};
  }
}