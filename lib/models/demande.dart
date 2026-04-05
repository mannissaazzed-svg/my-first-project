class Demande {
  final int num;
  final String objet;
  final String lieu;
  final String dateDepart;
  final String dateRetour;
  final String modeTransport;
  final String agentNom;

  Demande({
    required this.num,
    required this.objet,
    required this.lieu,
    required this.dateDepart,
    required this.dateRetour,
    required this.modeTransport,
    required this.agentNom,
  });

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      num: json["NUM"] ?? 0,
      objet: json["OBJET"] ?? "",
      lieu: json["LIEU"] ?? "",
      dateDepart: json["DateDepart"] ?? "",
      dateRetour: json["DateRetour"] ?? "",
      modeTransport: json["Mode_Transport"] ?? "",
      agentNom: json["agentName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "NUM": num,
      "OBJET": objet,
      "LIEU": lieu,
      "DateDepart": dateDepart,
      "DateRetour": dateRetour,
      "Mode_Transport": modeTransport,
      "agentName": agentNom,
    };
  }
}






