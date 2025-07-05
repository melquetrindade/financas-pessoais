import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RepositoryContas extends ChangeNotifier {
  List<Conta> _contas = [];
  late FirebaseFirestore db;
  late AuthService auth;
  bool isLoading = true;

  RepositoryContas({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readContas();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readContas() async {
    if (auth.usuario != null && _contas.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.uid}/contas').get();
      snapshot.docs.forEach((item) {
        _contas.add(Conta(
            nome: item['nome'],
            banco:
                Banco(nome: item['banco']['nome'], img: item['banco']['img']),
            saldo: item['saldo']));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  notifica() {
    notifyListeners();
  }

  saveContas(Conta conta, Function feedback) async {
    bool existe = _contas.any((c) => c.nome == conta.nome);
    if (existe == false) {
      feedback(true);
      _contas.add(conta);
      await db
          .collection('usuarios/${auth.usuario!.uid}/contas')
          .doc(conta.nome)
          .set({
        'nome': conta.nome,
        'saldo': conta.saldo,
        'banco': {'nome': conta.banco.nome, 'img': conta.banco.img}
      });
    } else {
      feedback(false);
    }
  }

  removeConta(Conta conta, Function feedback) async {
    try {
      _contas.removeWhere((c) => c.nome == conta.nome);
      await db
          .collection('usuarios/${auth.usuario!.uid}/contas')
          .doc(conta.nome)
          .delete();
      feedback(true, 'Conta deletada com sucesso!');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível excluir a conta!");
    }
  }

  updateConta(Conta conta, Function feedback) async {
    try {
      await db
          .collection('usuarios/${auth.usuario!.uid}/contas')
          .doc(conta.nome)
          .update({
        'saldo': conta.saldo,
        'banco': {'img': conta.banco.img, 'nome': conta.banco.nome}
      });
      for (var c in _contas) {
        if (c.nome == conta.nome) {
          c.banco = conta.banco;
          c.saldo = conta.saldo;
          break;
        }
      }
      feedback(true, 'Conta atualizada com sucesso!');
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível atualizar a conta!");
    }
  }

  List<Conta> get contas => _contas;
}