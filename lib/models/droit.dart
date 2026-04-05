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

