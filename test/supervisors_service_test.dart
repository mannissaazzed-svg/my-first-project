import 'package:flutter_test/flutter_test.dart';
import 'package:mobi_relex/services/supervisors_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';

void main() {
  late MockApiService mockApi;
  late SupervisorsService supervisorService;

  setUp(() {
    mockApi = MockApiService();
    supervisorService = SupervisorsService(mockApi);
  });

  test("Get supervisors", () async {
    final supervisors = await supervisorService.getProfils();
    expect(supervisors.isNotEmpty, true);
    expect(supervisors.length, 5);
    expect(supervisors[0].agentNom, "Ali Benkhaled");
    expect(supervisors[0].role, "Directeur des opérations");
    expect(supervisors[4].agentNom, "Omar Haddad");
    expect(supervisors[4].role, "Superviseur général");
  });
}






