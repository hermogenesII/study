import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/services/rtdb_service.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //To check if the user is logged in or not
  bool isLoggedIn() => FirebaseAuth.instance.currentUser != null;

  //To create new user
  //Used for registratin page
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await RTDBService().saveUserInfoToRTDB(_auth.currentUser!);
  }

  //To Login on an existing account
  //Used for login page
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //To sign out
  Future<void> signOut() async {
    await RTDBService().setUserOffline();
    // await RTDBService().setupPresence();
    // Explicitly set user status to offline during sign-out

    await _auth.signOut();
  }

  //To get current user information
  User? getCurrentUserInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  //To update user information
  Future<void> updateUserInfo(String? displayName, String? photoURL) async {
    final user = getCurrentUserInfo();
    if (user != null) {
      await user.updateProfile(displayName: displayName, photoURL: photoURL);
      await user.reload();
    }
  }

  //Sign in with Google Account
  // Future<void> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   if (googleUser != null) {
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //   }
  // }
}
