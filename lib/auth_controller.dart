import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // tambahkan di splashscreen
    // _auth.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     isLoggedIn.value = false;
    //     Get.offAll(() => const LoginPage());
    //   } else {
    //     isLoggedIn.value = true;
    //     Get.offAll(() => const HomePage());
    //   }
    // });
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // batal login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // proses sign in ke Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // kalau berhasil (user tidak null)
      if (userCredential.user != null) {
        Get.snackbar(
          "Success",
          "Welcome, ${userCredential.user!.displayName ?? 'User'}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Login gagal: $e");
      print("error login " + e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
