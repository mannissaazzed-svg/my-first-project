class Droit {

  final String agentNom;
  final String role;
  

  Droit({
    required this.agentNom,
    required this.role,
    
  });

  factory Droit.fromJson(Map<String, dynamic> json) {

    return Droit(
      agentNom: json["agent_nom"] ?? "",
      role: json["role"] ?? "",
      
    );

  }

}

/*
class SupervisorProfile {

  final int NUM;
  final int GROUP_ID;
  final String AGENT_NOM;
  final String Role;

  SupervisorProfile({
    required this.NUM,
    required this.GROUP_ID,
    required this.AGENT_NOM,
    required this.Role,
  });

  factory SupervisorProfile.fromJson(Map<String, dynamic> json) {
    return SupervisorProfile(
      NUM: json['NUM'],
      GROUP_ID: json['GROUP_ID'],
      AGENT_NOM: json['AGENT_NOM'],
      Role: json['job'] ?? "Supervisor",
    );
  }
}
*/