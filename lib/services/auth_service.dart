import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:circlesapp/shared/user.dart' as local;
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  var user = FirebaseAuth.instance.currentUser;

  Future<UserCredential> googleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> googleSignUp() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    UserService.dataUser = local.User.empty();
    GoalService.goals = Future.value(
      List.empty(
        growable: true,
      ),
    );

    final openedBox = Hive.box("userBox");

    const secureStorage = FlutterSecureStorage();

    openedBox.clear();

    secureStorage.deleteAll();

    await FirebaseAuth.instance.signOut();
  }
}
