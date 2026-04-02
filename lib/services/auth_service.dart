/*import 'api_service.dart';

class AuthService {
  final ApiService api;
  AuthService(this.api);

  Future<String?> login(String compte, String password) async {
    final data = await api.post(
      'auth/login',
      {'compte': compte, 'password': password},
    );
    final token = data['access_token'];
    if (token != null) api.token = token;
    return token;
  }
}
*/




import 'api_service.dart';

class AuthService {
  final ApiService api;
  AuthService(this.api);

  Future<String?> login(String compte, String password) async {
    final data = await api.post(
      "auth/login",
      {"compte": compte, "password": password},
    );
    return data["access_token"];
  }
}



