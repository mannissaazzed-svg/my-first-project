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







/*class Mission {

  final int NUM;
  final int GROUP_ID;
  final String DateDepart;
  final String DateRetour;
  final String Mode_Transport;
  final String LIEU;
  final String OBJET;
  final String Parcours;
  final String agentName;

  Mission({
    required this.NUM,
    required this.GROUP_ID,
    required this.DateDepart,
    required this.DateRetour,
    required this.Mode_Transport,
    required this.LIEU,
    required this.OBJET,
    required this.Parcours,
    required this.agentName
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      NUM: json["NUM"],
      GROUP_ID: json["GROUP_ID"],
      DateDepart: json["DateDepart"],
      DateRetour: json["DateRetour"],
      Mode_Transport: json["Mode_Transport"],
      LIEU: json["LIEU"],
      OBJET: json["OBJET"],
      Parcours: json["Parcours"],
      agentName: json["agentName"]
    );
  }
  

 factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      NUM: json["NUM"] ?? 0,
      GROUP_ID: json["GROUP_ID"] ?? 0,
      DateDepart: json["DateDepart"] ?? "",
      DateRetour: json["DateRetour"] ?? "",
      Mode_Transport: json["Mode_Transport"] ?? "",
      LIEU: json["LIEU"] ?? "",
      OBJET: json["OBJET"] ?? "",
      Parcours: json["Parcours"] ?? "",
      agentName: json["agentName"] ?? "",
    );
  } 
}
*/