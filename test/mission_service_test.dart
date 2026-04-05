import 'package:flutter_test/flutter_test.dart';
import 'package:mobi_relex/services/mission_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';

void main() {
  late MockApiService mockApi;
  late MissionsService missionService;

  setUp(() {
    mockApi = MockApiService();
    missionService = MissionsService(mockApi);
  });

  test("Get missions", () async {
    final missions = await missionService.getDemandes("ANY");
    expect(missions.length, 3);
    expect(missions[0].agentNom, "BENKCHIDA FOUAD");
    expect(missions[1].objet, "Workshop Développement Java");
    expect(missions[2].num, 354);
  });

  test("Approve mission", () async {
    final result = await missionService.approuver(347);
    expect(result, true);
  });

  test("Reject mission", () async {
    final result = await missionService.rejeter(347, "Test motif");
    expect(result, true);
  });
}






