import 'package:flutter/material.dart';
import 'package:mci_fitness_app/controller/AuthController.dart';

//Login-Seite wird angezeigt wenn die App das erste Mal geöffnet wird und kein Nutzer angemeldet ist
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
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54,
                    width: 2.0,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(color: Colors.white54),
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white54,
                    width: 2.0,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.white54),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              //Sind die Login-Eingaben richhtig wird man angemeldet und auf das Dashboard weitergeleitet
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                AuthController.instance.login(email, password);
              },
              label: Text("Login",
                  style: TextStyle(fontSize: 16, color: Colors.white54)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
