import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';

class RepositoryCartao extends ChangeNotifier {
  List<Cartao> _cartoes = [];
  late FirebaseFirestore db;
  late AuthService auth;
  bool isLoading = true;

  RepositoryCartao({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readCartoes();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  notifica() {
    notifyListeners();
  }

  _readCartoes() async {
    if (auth.usuario != null && _cartoes.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.uid}/cartoes').get();
      snapshot.docs.forEach((item) {
        _cartoes.add(Cartao(
            nome: item['nome'],
            icone:
                Banco(nome: item['icone']['nome'], img: item['icone']['img']),
            limite: item['limite'],
            diaFechamento: item['diaFechamento'],
            diaVencimento: item['diaVencimento'],
            conta: Conta(
                nome: item['conta']['nome'],
                banco: Banco(
                    nome: item['conta']['banco']['nome'],
                    img: item['conta']['banco']['img']),
                saldo: item['conta']['saldo'])));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  saveCartao(Cartao cartao, Function feedback) async {
    bool existe = _cartoes.any((c) => c.nome == cartao.nome);
    if (existe == false) {
      feedback(true);
      _cartoes.add(cartao);
      await db
          .collection('usuarios/${auth.usuario!.uid}/cartoes')
          .doc(cartao.nome)
          .set({
        'nome': cartao.nome,
        'icone': {'nome': cartao.icone.nome, 'img': cartao.icone.img},
        'limite': cartao.limite,
        'diaFechamento': cartao.diaFechamento,
        'diaVencimento': cartao.diaVencimento,
        'conta': {
          'nome': cartao.conta.nome,
          'saldo': cartao.conta.saldo,
          'banco': {
            'nome': cartao.conta.banco.nome,
            'img': cartao.conta.banco.img
          }
        }
      });
    } else {
      feedback(false);
    }
  }

  removeCartao(Cartao cartao, Function feedback) async {
    try {
      _cartoes.removeWhere((c) => c.nome == cartao.nome);
      await db
          .collection('usuarios/${auth.usuario!.uid}/cartoes')
          .doc(cartao.nome)
          .delete();
      feedback(true, 'Cartão deletado com sucesso!');
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível excluir o cartão!");
    }
  }

  updateCartao(Cartao cartao, Function feedback) async {
    try {
      await db
          .collection('usuarios/${auth.usuario!.uid}/cartoes')
          .doc(cartao.nome)
          .update({
        'icone': {'nome': cartao.icone.nome, 'img': cartao.icone.img},
        'limite': cartao.limite,
        'diaFechamento': cartao.diaFechamento,
        'diaVencimento': cartao.diaVencimento,
        'conta': {
          'nome': cartao.conta.nome,
          'saldo': cartao.conta.saldo,
          'banco': {
            'nome': cartao.conta.banco.nome,
            'img': cartao.conta.banco.img
          }
        }
      });
      for (var c in _cartoes) {
        if (c.nome == cartao.nome) {
          c.icone = cartao.icone;
          c.diaFechamento = cartao.diaFechamento;
          c.diaVencimento = cartao.diaVencimento;
          c.limite = cartao.limite;
          c.conta = cartao.conta;
          break;
        }
      }
      feedback(true, 'Cartão atualizado com sucesso!');
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível atualizar o cartão!");
    }
  }

  List<Cartao> get cartoes => _cartoes;
}