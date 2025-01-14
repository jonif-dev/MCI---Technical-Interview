import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Singleton-Instance für den Zugriff auf AuthController
  static AuthController instance = Get.find();

  // Firebase-User als reaktive Variable
  late Rx<User?> firebaseUser;

  // Authentifizierungsstatus und Ladezustand als reaktive Variablen
  var isAuthenticated = false.obs;
  var isLoading = true.obs;

  // Initialisierung bei Laden des Controllers
  @override
  void onReady() {
    super.onReady();

    // Bindet den aktuellen Firebase-User und lauscht auf Änderungen
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Reagiert auf Änderungen des Authentifizierungsstatus
    ever(firebaseUser, _handleAuthChanged);
  }

  // Aktualisiert Authentifizierungsstatus und Ladezustand
  void _handleAuthChanged(User? user) {
    isLoading.value = false; // Beendet Ladezustand
    isAuthenticated.value = user != null; // Setzt Authentifizierungsstatus
  }

  // Gibt die User-ID des aktuellen Benutzers zurück, falls vorhanden
  String? get userId {
    return firebaseUser.value?.uid;
  }

  // Führt den Login-Prozess durch
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Zeigt eine Fehlermeldung bei Login-Problemen an
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Meldet den aktuellen Benutzer ab
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
