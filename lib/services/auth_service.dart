import 'api_service.dart';

class AuthService {
  final ApiService api;

  AuthService(this.api);

  Future<String?> login(String compte, String password) async {
    final data = await api.post(
      "auth/login",
      {
        "compte": compte,
        "password": password,
      },
    );

    api.token = data["access_token"];
    return data["access_token"];
  }
}






