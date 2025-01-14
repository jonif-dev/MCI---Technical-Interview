import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';
import 'package:mci_fitness_app/view/LoginView.dart';
import 'package:mci_fitness_app/view/DashboardView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/dashboard', page: () => DashboardView()),
      ],
      theme: ThemeData(
        // Setze die globalen Farben im ThemeData
        scaffoldBackgroundColor:
            Color(0xFF151515), // Hintergrundfarbe für Scaffold

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF151515), // AppBar-Hintergrundfarbe
          titleTextStyle: TextStyle(
              color: Color(0xFFF3F3F3),
              fontSize: 20), // Titeltextfarbe der AppBar
        ),
      ),
      home: Obx(() {
        final authController = Get.find<AuthController>();
        if (authController.isLoading.value) {
          // Zeige einen Splash-Screen oder Loading-Indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (authController.firebaseUser.value == null) {
          // Nutzer ist nicht angemeldet
          return LoginView();
        } else {
          // Nutzer ist angemeldet
          return DashboardView();
        }
      }),
    );
  }
}
