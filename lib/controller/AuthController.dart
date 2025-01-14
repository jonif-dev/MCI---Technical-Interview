import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find(); // Singleton-Instance
  late Rx<User?> firebaseUser;

  var isAuthenticated = false.obs;
  var isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    isLoading.value = false; // Ladeanzeige stoppen
    isAuthenticated.value = user != null;
  }

  String? get userId {
    return firebaseUser.value?.uid;
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
