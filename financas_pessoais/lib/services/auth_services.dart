import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  bool onboardingOneView = false;
  bool onboardingTwoView = false;
  bool loginOrSigin = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = user == null ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  controllerPags(String pag) {
    if (pag == "onboardingOne") {
      onboardingOneView = true;
    } else if (pag == "onboardingTwo") {
      onboardingTwoView = true;
    } else {
      loginOrSigin = !loginOrSigin;
    }
    notifyListeners();
  }

  registrar(String nome, String email, String senha) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      if (result.user != null) {
        loginOrSigin = !loginOrSigin;
        await result.user!.updateDisplayName(nome);
        await result.user!.reload();
      }

      _getUser();
    } on FirebaseAuthException catch (e) {
      print("erro: ${e.code}");
      if (e.code == "weak-password") {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado!');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      print(e);
      throw AuthException("Email ou senha incorretos!");
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
