import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';

class RepositoryContas extends ChangeNotifier {
  List<Conta> _contas = [];
  late FirebaseFirestore db;
  late AuthService auth;

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
    notifyListeners();
  }

  saveContas(Conta conta, Function teste) async {
    bool existe = _contas.any((c) => c.nome == conta.nome);
    if (existe == false) {
      _contas.add(conta);
      await db
          .collection('usuarios/${auth.usuario!.uid}/contas')
          .doc(conta.nome)
          .set({
        'nome': conta.nome,
        'saldo': conta.saldo,
        'banco': {'nome': conta.banco.nome, 'img': conta.banco.img}
      });
      teste(true);
    } else {
      print("Não salvou pois já existia uma conta com este nome");
      teste(false);
    }
    notifyListeners();
  }

  List<Conta> get contas => _contas;
}

/* 
final List<Conta> _contas = [
  Conta(nome: "Banco do Brasil", saldo: "1.567,90", banco: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png")),
  Conta(nome: "Caixa", saldo: "5.633,90", banco: Banco(nome: "Caixa", img: "assets/bancos/caixa.jpg")),
  Conta(nome: "Banco PAN", saldo: "10.000,00", banco: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png")),
  Conta(nome: "Poupança", saldo: "8.500,00", banco: Banco(nome: "Cofrinho", img: "Cofrinho")),
  Conta(nome: "Next", saldo: "2.003,90", banco: Banco(nome: "Next", img: "assets/bancos/next.jpg"))
];
*/