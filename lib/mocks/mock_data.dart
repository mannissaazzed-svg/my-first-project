class MockData {
  static const loginSuccess = {
    "success": true,
    "access_token": "fake_token_123",
  };

  static const loginFail = {
    "success": false,
    "message": "Email ou mot de passe incorrect",
  };

  static const supervisorsList = [
    {"agent_nom": "Ali Benkhaled", "role": "Directeur des opérations"},
    {"agent_nom": "Sara Toumi", "role": "Responsable de projet"},
    {"agent_nom": "Karim Bensalem", "role": "Chef d'équipe"},
    {"agent_nom": "Nadia Cherif", "role": "Coordinatrice technique"},
    {"agent_nom": "Omar Haddad", "role": "Superviseur général"}
  ];

  static const missions = {
    "items": [
      {
        "NUM": 347,
        "OBJET": "Workshop Développement Java",
        "LIEU": "DRIK",
        "DateDepart": "17/04/22",
        "DateRetour": "18/04/22",
        "Mode_Transport": "Avion",
        "agentName": "BENKCHIDA FOUAD"
      },
      {
        "NUM": 348,
        "OBJET": "Workshop Développement Java",
        "LIEU": "DRIK",
        "DateDepart": "17/04/22",
        "DateRetour": "18/04/22",
        "Mode_Transport": "Avion",
        "agentName": "AID HAKIM"
      },
      {
        "NUM": 354,
        "OBJET": "Mission Test DTI",
        "LIEU": "RA2K",
        "DateDepart": "30/05/22",
        "DateRetour": "31/05/22",
        "Mode_Transport": "Avion",
        "agentName": "TALEB REDA"
      }
    ]
  };
}