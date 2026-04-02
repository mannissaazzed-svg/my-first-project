/*import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'droit_screen.dart';

class LoginScreen extends StatefulWidget {
  final ApiService api;
  const LoginScreen({super.key, required this.api});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final compteController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthService(widget.api);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: compteController,
                decoration: const InputDecoration(hintText: 'Compte'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  final compte = compteController.text.trim();
                  final password = passwordController.text.trim();

                  if (compte.isEmpty || password.isEmpty) return;

                  try {
                    final token = await authService.login(compte, password);
                    if (token != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupervisorsScreen(api: widget.api),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login failed')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                },
                child: const Text('Se Connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/


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
























/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'droit_screen.dart';

import '../services/auth_service.dart';
import '../mocks/mock_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
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
                      emailController,
                      "Email",
                      icon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "mot de passe",
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

                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isNotEmpty && password.isNotEmpty) {

                            final token = await authService.login(
                              email,
                              password,
                            );

                            if (token != null) {

                              apiService.token = token;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DroitScreen(api: apiService),
                                ),
                              );

                            } else {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("La connexion a échoué"),
                                ),
                              );

                            }

                          } else {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Veuillez saisir votre email et mot de passe",
                                ),
                              ),
                            );

                          }

                        },

                        child: const Text("Se Connecter"),
                      ),
                    ),

                    TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );

                      },

                      child: const Text(
                        "Vous n'avez pas de compte ? Inscrivez-vous",
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
*/

