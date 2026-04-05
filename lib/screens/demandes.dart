import 'package:flutter/material.dart';
import '../models/demande.dart';
import 'demande_detail.dart';

class DemandesPage extends StatelessWidget {
  final List<Demande> missions; 

  const DemandesPage({super.key, required this.missions}); // parameter required

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text("Demandes"),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: missions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final Demande demande = missions[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DemandeDetails(demande: demande),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    demande.objet,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    demande.lieu,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text("${demande.dateDepart} → ${demande.dateRetour}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.flight, size: 16),
                      const SizedBox(width: 6),
                      Text(demande.modeTransport),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




































