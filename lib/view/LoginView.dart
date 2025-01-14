import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: TextStyle(color: Colors.white54),
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Label in Weiß
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54, // Weiße Umrandung
                    width: 2.0, // Optional: Dicke der Umrandung
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54, // Weiße Umrandung bei Fokussierung
                    width: 2.0,
                  ),
                ),
                hintStyle: TextStyle(
                    color: Colors.white54), // Hint-Text in Weiß mit Transparenz
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(color: Colors.white54),
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white), // Label in Weiß
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54, // Weiße Umrandung
                    width: 2.0, // Optional: Dicke der Umrandung
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54, // Weiße Umrandung bei Fokussierung
                    width: 2.0,
                  ),
                ),
                hintStyle: TextStyle(
                    color: Colors.white54), // Hint-Text in Weiß mit Transparenz
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                AuthController.instance.login(email, password);
              },
              // Play-Icon
              label: Text("Login",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white54)), // Text auf dem Button
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 63, 63, 63), // Button Hintergrundfarbe
                minimumSize: Size(double.infinity,
                    50), // Breite des Buttons (füllt die Breite des Bildschirms)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Abgerundete Ecken
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
