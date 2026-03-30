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







/*import 'package:mobi_relex/services/supervisors_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';
import 'package:mobi_relex/mocks/mock_data.dart';


void main() {
  late MockApiService mockApi;
  late SupervisorsService supervisorService;

  setUp(() {
    mockApi = MockApiService();
    supervisorService = SupervisorsService(mockApi);
  });

  test("Get supervisors", () async {
    final list = await supervisorService.getProfils();
    expect(list.isNotEmpty, true);

    expect(supervisors.length, 5);
    expect(supervisors[0]["name"], "Ali Benkhaled");
    expect(supervisors[0]["job"], "Directeur des opérations");
    expect(supervisors[4]["name"], "Omar Haddad");
    expect(supervisors[4]["job"], "Superviseur général");
  });
}

*/










/*import 'package:flutter_test/flutter_test.dart';
import 'package:mobi_relex/services/mission_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';

void main() {

  late MissionsService service;

  setUp(() {

    final mockApi = MockApiService();
    service = MissionsService(mockApi);

  });

  test("Get missions", () async {

    final list = await service.getDemandes();

    expect(list.isNotEmpty, true);

  });

  test("Approve mission", () async {

    final result =
    await service.approuver(347);

    expect(result, true);

  });

}


*/











/*import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobi_relex/services/mission_service.dart';
import 'package:mobi_relex/mocks/mock_api_service.dart';
import 'package:mobi_relex/mocks/mock_data.dart';

void main() {
  late MockApiService mockApi;
  late MissionsService missionService;

  setUp(() {
    mockApi = MockApiService();
    missionService = MissionsService(mockApi);
  });

  test("Get missions", () async {
    final list = await missionService.getDemandes);

    expect(missions.length, 3);
    expect(missions[0]["agentName"], "BENKCHIDA FOUAD");
    expect(missions[1]["OBJET"], "Workshop Développement Java");
    expect(missions[2]["NUM"], 354);
  });
}
*/