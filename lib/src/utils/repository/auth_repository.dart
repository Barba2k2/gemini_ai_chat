import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gamini_ai_chat/src/screens/chat/chat_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'exceptions/exceptions.dart';
import 'result/login_result.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  Rx<User?> _firebaseUser = Rx<User?>(null);
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    super.onReady();
  }

  setInitialScreen(User? user) async {
    user == null; // ? welcome : chat
  }

  User? get firebaseUser => _firebaseUser.value;
  String get getUserId => firebaseUser?.uid ?? '';
  String get getUserEmail => firebaseUser?.email ?? '';
  String get getDisplayName => firebaseUser?.displayName ?? '';

  //* ------------- Email n Passwoord Auth ------------- *//
  bool isInvalidCredentialsError(FirebaseAuthException e) {
    return e.code == 'user-not-found' || e.code == 'wrong-password';
  }

  /// [EmailAuth] - LOGIN
  Future<MyLoginResult> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return MyLoginResult.success();
    } on FirebaseAuthException catch (e) {
      if (isInvalidCredentialsError(e)) {
        return MyLoginResult.failure(
            'Verifique o e-mail e/ou a senha e tente novamente.');
      } else {
        final result = MyExceptions.fromCode(e.code);
        throw result.message;
      }
    } catch (e) {
      log('Erro ao efeutuar o login com email: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro ao registrar usuario: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  /// ---------- [Social Login] ----------

  /// [GoogleAuth]
  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignInAccount? google;

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      google = googleUser;
    } catch (e) {
      log('Erro de autenticação com o Google: $e');
    }

    try {
      final GoogleSignInAuthentication? googleAuth =
          await google?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // navigate to chat screen
      Get.to(() => const ChatPage());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Erro do Firestore an criacao de usuario com Google: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro de autenticacao de usuario com Goole: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  Future<void> resetPasswordEmail(String email) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .sendPasswordResetEmail(email: email)
          .then((value) => log('Email enviado'));
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      log('Erro ao enviar email de recuperacao de senha: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  //? Any authentication
  /// [LogoutUser]
  Future<void> logoutUser() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => {/* Welcome Page */});
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      log('Erro ao deslogar: $e');
      throw 'Nao foi possivel sair. Tente Novamente';
    }
  }
}
