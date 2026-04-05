import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'droit_screen.dart';
import '../services/auth_service.dart';
import '../mocks/mock_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final compteController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  final apiService = MockApiService();
  late final AuthService authService = AuthService(apiService);

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
            child: SingleChildScrollView(
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 167, 163, 163),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      "Se Connecter",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    customField(
                      compteController,
                      "Compte",
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        prefixIcon: const Icon(Icons.lock_outline),

                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(

                        onPressed: () async {

                          final compte = compteController.text.trim();
                          final password = passwordController.text.trim();

                          if (compte.isNotEmpty && password.isNotEmpty) {

                            final token = await authService.login(
                              compte,
                              password,
                            );

                            if (token != null) {

                              apiService.token = token;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SupervisorsScreen(api: apiService),
                                ),
                              );

                            } else {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("La connexion a échoué"),
                                ),
                              );

                            }

                          } else {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Veuillez saisir votre compte et mot de passe",
                                ),
                              ),
                            );

                          }

                        },

                        child: const Text("Se Connecter"),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget customField(
    TextEditingController controller,
    String hint,
    {required IconData icon}
  ) {

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );

  }
}
























