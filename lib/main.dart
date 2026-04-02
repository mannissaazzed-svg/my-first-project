/*import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobirelex',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginScreen(
        api: ApiService(baseUrl: 'http://10.0.2.2:8000'), 
      ),
    );
  }
}
*/









import 'package:flutter/material.dart';
import 'package:mobi_relex/screens/login_screen.dart';
import 'package:mobi_relex/screens/demandes.dart';
import 'package:mobi_relex/screens/splash_screen.dart';
import 'package:mobi_relex/screens/droit_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home: SplashScreen()
    );
  }
} 











