import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/view/LoginView.dart';
import 'package:mci_fitness_app/view/DashboardView.dart';

void main() async {
  // Initialisiert Widgets und Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Registriert den AuthController als Singleton
  Get.put(AuthController());

  // Startet die App
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Entfernt das Debug-Banner
      getPages: [
        // Definiert die Routen der App
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/dashboard', page: () => DashboardView()),
      ],
      home: Obx(() {
        // Reagiert auf Änderungen im Authentifizierungsstatus
        final authController = Get.find<AuthController>();

        if (authController.isLoading.value) {
          // Zeigt einen Ladebildschirm, während der Auth-Status geprüft wird
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (authController.firebaseUser.value == null) {
          // Leitet auf die Login-Seite weiter, wenn kein Benutzer angemeldet ist
          return LoginView();
        } else {
          // Leitet auf das Dashboard weiter, wenn ein Benutzer angemeldet ist
          return DashboardView();
        }
      }),
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color(0xFF151515), // Setzt die Hintergrundfarbe
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151515), // Setzt die Farbe der AppBar
          titleTextStyle: TextStyle(
              color: Color(0xFFF3F3F3), fontSize: 20), // Textstil der AppBar
        ),
      ),
    );
  }
}
