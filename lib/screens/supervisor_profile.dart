/*
import 'package:flutter/material.dart';
import '../models/droit.dart';
import 'package:mobi_relex/screens/demandes.dart';

class SupervisorProfilePage extends StatelessWidget {
  final SupervisorProfile supervisor;

  const SupervisorProfilePage({super.key, required this.supervisor});

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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(Icons.person, size: 80, color: Colors.blueGrey),
                  const SizedBox(height: 15),

                  Text(
                    supervisor.AGENT_NOM,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "NUM (ID): ${supervisor.NUM}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "GROUP ID: ${supervisor.GROUP_ID}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Role: ${supervisor.Role}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.assignment),
                      label: const Text("Voir les missions"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 128, 153, 165),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {

                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DemandesPage(),
                          ),
                        );

                      },
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
*/