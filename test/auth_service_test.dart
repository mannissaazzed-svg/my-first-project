import 'package:flutter_test/flutter_test.dart';
import 'package:mobi_relex/services/auth_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';

void main() {
  late MockApiService mockApi;
  late AuthService authService;

  setUp(() {
    mockApi = MockApiService();
    authService = AuthService(mockApi);
  });

  test("Login success", () async {
    final token = await authService.login("test@mail.com", "1234");
    expect(token, "fake_token_123");
  });

  test("Login fail", () async {
    final token = await authService.login("wrong@mail.com", "0000");
    expect(token, null);
  });
}










