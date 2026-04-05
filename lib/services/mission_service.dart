import '../models/demande.dart';
import 'api_service.dart';

class MissionsService {
  final ApiService api;
  MissionsService(this.api);

  Future<List<Demande>> getDemandes(String structure) async {
    final data = await api.get("demandes/en-attente?structure=$structure&page=1&size=20");
    final List items = data["items"] ?? [];
    return items.map((e) => Demande.fromJson(e)).toList();
  }

  Future<bool> approuver(int num) async {
    await api.put("demandes/$num/approuver", {});
    return true;
  }

  Future<bool> rejeter(int num, String motif) async {
    await api.put("demandes/$num/rejeter", {"motif": motif});
    return true;
  }
}




/*
import 'api_service.dart';
import '../models/demande.dart';

class MissionsService {
  final ApiService api;

  MissionsService(this.api);

  Future<List<Demande>> getDemandes(
    String structure,
    {int page = 1, int size = 20}
  ) async {

    final data = await api.get(
      "demandes/en-attente?structure=$structure&page=$page&size=$size"
    );

    final List items = data["items"] ?? [];

    return items.map((e) => Demande.fromJson(e)).toList();
  }

  Future<void> approuver(int num) async {
    await api.put("demandes/$num/approuver", {});
  }

  Future<void> rejeter(int num, String motif) async {
    await api.put(
      "demandes/$num/rejeter",
      {"motif": motif},
    );
  }
}
*/


