import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/demande.dart';
import '../mocks/mock_data.dart';
import 'demandes.dart';

class SupervisorsScreen extends StatefulWidget {
  final ApiService api;

  const SupervisorsScreen({super.key, required this.api});

  @override
  State<SupervisorsScreen> createState() => _SupervisorsScreenState();
}

class _SupervisorsScreenState extends State<SupervisorsScreen> {
  Map<String, dynamic>? selectedWorker;
  List<Map<String, dynamic>> workersList = [];
  List<Demande> missionsList = [];

  @override
  void initState() {
    super.initState();
    loadWorkers();
    loadMissions();
  }

  void loadWorkers() async {
    final data = await widget.api.get("droits/mes-profils");
    setState(() {
      workersList = List<Map<String, dynamic>>.from(data);
    });
  }

  void loadMissions() async {
    final data = await widget.api.get("demandes/en-attente");
    final items = data['items'] ?? [];
    setState(() {
      missionsList = List<Demande>.from(
        items.map((e) => Demande(
          num: e["NUM"],
          objet: e["OBJET"],
          lieu: e["LIEU"],
          dateDepart: e["DateDepart"],
          dateRetour: e["DateRetour"],
          modeTransport: e["Mode_Transport"],
          agentNom: e["agentName"],
        )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "assets/images/business_travel.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Choisir un responsable",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 25),

                  DropdownButtonFormField<Map<String, dynamic>>(
                    hint: const Text("Sélectionnez un superviseur"),
                    value: selectedWorker,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: workersList.map((worker) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: worker,
                        child: Text("${worker['agent_nom']} - ${worker['role']}"),
                      );
                    }).toList(),
                    onChanged: (worker) {
                      setState(() {
                        selectedWorker = worker;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
  width: 180,
  height: 45,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple, 
      foregroundColor: Colors.white, 
      elevation: 5, // ظل خفيف
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: selectedWorker == null
        ? null
        : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DemandesPage(
                  missions: missionsList,
                ),
              ),
            );
          },
    child: const Text("Voir les missions"),
  ),
),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
