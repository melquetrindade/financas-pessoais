import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';

class RepositoryFatura extends ChangeNotifier {
  final List<Fatura> _faturas = [];
  late FirebaseFirestore db;
  late AuthService auth;
  bool isLoading = true;

  RepositoryFatura({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readFaturas();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  notifica() {
    notifyListeners();
  }

  Color extrairCor(String corTexto) {
    String corLimpa = corTexto.replaceAll('"', '');
    final regex = RegExp(r'0x[0-9a-fA-F]+');
    final match = regex.firstMatch(corLimpa);

    if (match != null) {
      final hex = match.group(0)!;
      return Color(int.parse(hex));
    }
    return Colors.black;
  }

  IconData converterUnicodeParaIcone(String unicode) {
    String codigo = unicode
        .replaceAll('IconData(', '')
        .replaceAll(')', '')
        .replaceAll('U+', '');
    int codePoint = int.parse(codigo, radix: 16);

    return IconData(
      codePoint,
      fontFamily: 'MaterialIcons',
    );
  }

  _readFaturas() async {
    if (auth.usuario != null && _faturas.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.uid}/faturas').get();
      snapshot.docs.forEach((item) {
        final pagamentosJson = item['pagamentos'] as List<dynamic>;
        final pagamentos = pagamentosJson.map((pag) {
          return Pagamentos(data: pag['data'], valor: pag['data']);
        }).toList();

        final lancamentosJson = item['lancamentos'] as List<dynamic>;
        final lancamentos = lancamentosJson.map((lanc) {
          return Lancamentos(
              valor: lanc['valor'],
              descricao: lanc['descricao'],
              data: lanc['data'],
              eDespesa: lanc['eDespesa'],
              categoria: Categorias(
                  nome: lanc['categoria']['nome'],
                  cor: extrairCor(lanc['categoria']['cor']),
                  icon: converterUnicodeParaIcone(lanc['categoria']['icon'])),
              conta: lanc['conta'] != null
                  ? Conta(
                      nome: lanc['conta']['nome'],
                      banco: Banco(
                          nome: lanc['conta']['banco']['nome'],
                          img: lanc['conta']['banco']['img']),
                      saldo: lanc['conta']['saldo'])
                  : null,
              cartao: lanc['cartao'] != null
                  ? Cartao(
                      nome: lanc['cartao']['nome'],
                      icone: Banco(
                          nome: lanc['cartao']['icone']['nome'],
                          img: lanc['cartao']['icone']['img']),
                      limite: lanc['cartao']['limite'],
                      diaFechamento: lanc['cartao']['diaFechamento'],
                      diaVencimento: lanc['cartao']['diaVencimento'],
                      conta: Conta(
                        nome: lanc['cartao']['conta']['nome'],
                        banco: Banco(
                            nome: lanc['cartao']['conta']['banco']['nome'],
                            img: lanc['cartao']['conta']['banco']['img']),
                        saldo: lanc['cartao']['conta']['saldo'],
                      ))
                  : null);
        }).toList();

        _faturas.add(Fatura(
            lancamentos: lancamentos,
            cartao: Cartao(
                nome: item['cartao']['nome'],
                icone: Banco(
                    nome: item['cartao']['icone']['nome'],
                    img: item['cartao']['icone']['img']),
                limite: item['cartao']['limite'],
                diaFechamento: item['cartao']['diaFechamento'],
                diaVencimento: item['cartao']['diaVencimento'],
                conta: Conta(
                  nome: item['cartao']['conta']['nome'],
                  banco: Banco(
                      nome: item['cartao']['conta']['banco']['nome'],
                      img: item['cartao']['conta']['banco']['img']),
                  saldo: item['cartao']['conta']['saldo'],
                )),
            pagamentos: pagamentos,
            data: item['data'],
            foiPago: item['foiPago']));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  saveFaturas(Fatura fatura) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/faturas')
        .doc("${fatura.data.replaceAll('/', '')}&${fatura.cartao.nome}")
        .set({
      'lancamentos': fatura.lancamentos.map((item) {
        return {
          'valor': item.valor,
          'descricao': item.descricao,
          'data': item.data,
          'eDespesa': item.eDespesa,
          'categoria': {
            'nome': item.categoria.nome,
            'cor': "${item.categoria.cor}",
            'icon': "${item.categoria.icon}"
          },
          'conta': item.conta != null
              ? {
                  'nome': item.conta!.nome,
                  'saldo': item.conta!.saldo,
                  'banco': {
                    'nome': item.conta!.banco.nome,
                    'img': item.conta!.banco.img
                  }
                }
              : null,
          'cartao': item.cartao != null
              ? {
                  'nome': item.cartao!.nome,
                  'icone': {
                    'nome': item.cartao!.icone.nome,
                    'img': item.cartao!.icone.img
                  },
                  'limite': item.cartao!.limite,
                  'diaFechamento': item.cartao!.diaFechamento,
                  'diaVencimento': item.cartao!.diaVencimento,
                  'conta': {
                    'nome': item.cartao!.conta.nome,
                    'saldo': item.cartao!.conta.saldo,
                    'banco': {
                      'nome': item.cartao!.conta.banco.nome,
                      'img': item.cartao!.conta.banco.img
                    }
                  }
                }
              : null
        };
      }).toList(),
      'cartao': {
        'nome': fatura.cartao.nome,
        'icone': {
          'nome': fatura.cartao.icone.nome,
          'img': fatura.cartao.icone.img
        },
        'limite': fatura.cartao.limite,
        'diaFechamento': fatura.cartao.diaFechamento,
        'diaVencimento': fatura.cartao.diaVencimento,
        'conta': {
          'nome': fatura.cartao.conta.nome,
          'saldo': fatura.cartao.conta.saldo,
          'banco': {
            'nome': fatura.cartao.conta.banco.nome,
            'img': fatura.cartao.conta.banco.img
          }
        }
      },
      'pagamentos': fatura.pagamentos.map((item) {
        return {'data': item.data, 'valor': item.valor};
      }).toList(),
      'data': fatura.data,
      'foiPago': fatura.foiPago
    });
    _faturas.add(fatura);
    notifyListeners();
  }

  updateFatura(Fatura? fatura, Lancamentos lancamento) async {
    /*
    for (var f in _faturas) {
      if (f.data == fatura!.data && f.cartao.nome == fatura.cartao.nome) {
        //print('encontrou fatura');
        //print(f.lancamentos.length);
        f.lancamentos.add(lancamento);
        //print(f.lancamentos.length);
        /*
        f.lancamentos.forEach((lan) {
          print("\t\tlan: ${lan.valor}");
        });*/
        break;
      }
    }*/
    List<Lancamentos> lancamentosAux = [];
    lancamentosAux = fatura!.lancamentos;
    lancamentosAux.add(lancamento);

    await db
        .collection('usuarios/${auth.usuario!.uid}/faturas')
        .doc("${fatura.data.replaceAll('/', '')}&${fatura.cartao.nome}")
        .update({
      'lancamentos': lancamentosAux.map((item) {
        return {
          'valor': item.valor,
          'descricao': item.descricao,
          'data': item.data,
          'eDespesa': item.eDespesa,
          'categoria': {
            'nome': item.categoria.nome,
            'cor': "${item.categoria.cor}",
            'icon': "${item.categoria.icon}"
          },
          'conta': item.conta != null
              ? {
                  'nome': item.conta!.nome,
                  'saldo': item.conta!.saldo,
                  'banco': {
                    'nome': item.conta!.banco.nome,
                    'img': item.conta!.banco.img
                  }
                }
              : null,
          'cartao': item.cartao != null
              ? {
                  'nome': item.cartao!.nome,
                  'icone': {
                    'nome': item.cartao!.icone.nome,
                    'img': item.cartao!.icone.img
                  },
                  'limite': item.cartao!.limite,
                  'diaFechamento': item.cartao!.diaFechamento,
                  'diaVencimento': item.cartao!.diaVencimento,
                  'conta': {
                    'nome': item.cartao!.conta.nome,
                    'saldo': item.cartao!.conta.saldo,
                    'banco': {
                      'nome': item.cartao!.conta.banco.nome,
                      'img': item.cartao!.conta.banco.img
                    }
                  }
                }
              : null
        };
      }).toList(),
    });
    notifyListeners();
  }

  List<Fatura> get faturas => _faturas;
}