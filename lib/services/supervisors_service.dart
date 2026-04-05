import '../models/droit.dart';
import 'api_service.dart';

class SupervisorsService {
  final ApiService api;
  SupervisorsService(this.api);

  Future<List<Droit>> getProfils() async {
    final data = await api.get("droits/mes-profils");
    return (data as List).map((e) => Droit.fromJson(e)).toList();
  }
}









