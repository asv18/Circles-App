import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:circlesapp/shared/user.dart' as local;
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  Stream<User?> get userStream => FirebaseAuth.instance.authStateChanges();

  final _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;

  Future<UserCredential> googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> emailAndPasswordLogin(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> emailAndPasswordRegister(
    String email,
    String password,
    String name,
  ) async {
    final splitName = name.split(" ");
    UserService.dataUser.firstName = splitName[0];
    UserService.dataUser.lastName = splitName[1];
    UserService.dataUser.email = email;

    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    UserService.dataUser = local.User.empty();
    GoalService.goals = null;
    CircleService.circles = null;

    final openedBox = Hive.box("userBox");

    const secureStorage = FlutterSecureStorage();

    openedBox.clear();

    secureStorage.deleteAll();

    await FirebaseAuth.instance.signOut();
  }
}
