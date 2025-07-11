import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';

class RepositoryPerfil extends ChangeNotifier {
  String _nome = "";
  late AuthService auth;
  bool jaCarregou = false;
  bool loading = true;

  RepositoryPerfil({required this.auth}) {
    iniciarState();
  }

  String get nome => _nome;

  iniciarState() async {
    await _readName();
    jaCarregou = true;
  }

  resetNome() {
    _nome = '';
    _readName();
  }

  _readName() async {
    print("entrou no readName");
    if (auth.usuario != null) {
      _nome = '${auth.usuario!.displayName}';
      print("nome user: ${_nome}");
    }
    loading = false;
    notifyListeners();
  }

  updateNome(String nome) async {
    print("entrou no updateNome");
    await auth.usuario!.updateDisplayName(nome);
    await auth.usuario!.reload();
    print("Nome atualizado para: ${auth.usuario!.displayName}");
    _nome = nome;
    print("novo nome: ${_nome}");
    notifyListeners();
  }
}
