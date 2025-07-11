import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepositoryGastos extends ChangeNotifier {
  List<Gastos> _gastos = [];
  late FirebaseFirestore db;
  late AuthService auth;
  bool isLoading = true;
  bool jaCarregou = false;

  RepositoryGastos({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readGastos();
    jaCarregou = true;
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  resetLista() {
    _gastos = [];
    _readGastos();
  }

  notifica() {
    notifyListeners();
  }

  String extrairMesEAno(String dataCompleta) {
    List<String> partes = dataCompleta.split("/");
    String mes = partes[1];
    String ano = partes[2];
    return "$mes/$ano";
  }

  _readGastos() async {
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

    print("Lista de gastos: ${_gastos}");
    if (auth.usuario != null && _gastos.isEmpty) {
      final snapshot =
          await db.collection('usuarios/${auth.usuario!.uid}/gastos').get();
      snapshot.docs.forEach((item) {
        _gastos.add(Gastos(
            categoria: Categorias(
                nome: item['categoria']['nome'],
                cor: extrairCor(item['categoria']['cor']),
                icon: converterUnicodeParaIcone(item['categoria']['icon'])),
            valor: item['valor'],
            limite: item['limite'],
            data: item['data']));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  saveGasto(Gastos gasto, Function feedback) async {
    bool existe = _gastos.any((g) =>
        extrairMesEAno(g.data) == extrairMesEAno(gasto.data) &&
        g.categoria.nome == gasto.categoria.nome);
    if (existe == false) {
      feedback(true);
      _gastos.add(gasto);
      await db
          .collection('usuarios/${auth.usuario!.uid}/gastos')
          .doc("${gasto.data.replaceAll('/', '')}&${gasto.categoria.nome}")
          .set({
        'valor': gasto.valor,
        'limite': gasto.limite,
        'categoria': {
          'nome': gasto.categoria.nome,
          'cor': '${gasto.categoria.cor}',
          'icon': '${gasto.categoria.icon}',
        },
        'data': gasto.data
      });
    } else {
      feedback(false);
    }
  }

  updateGasto(Gastos gasto, Function feedback) async {
    try {
      await db
          .collection('usuarios/${auth.usuario!.uid}/gastos')
          .doc("${gasto.data.replaceAll('/', '')}&${gasto.categoria.nome}")
          .update({
        'limite': gasto.limite,
      });
      for (var g in _gastos) {
        if (extrairMesEAno(g.data) == extrairMesEAno(gasto.data) &&
            g.categoria.nome == gasto.categoria.nome) {
          g.limite = gasto.limite;
          break;
        }
      }
      feedback(true, 'Limite de gasto atualizado com sucesso!');
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      throw AuthException(
          "Erro, não foi possível atualizar o limite de gasto!");
    }
  }

  removeGasto(Gastos gasto, Function feedback) async {
    try {
      _gastos.removeWhere((g) =>
          extrairMesEAno(g.data) == extrairMesEAno(gasto.data) &&
          g.categoria.nome == gasto.categoria.nome);
      await db
          .collection('usuarios/${auth.usuario!.uid}/gastos')
          .doc("${gasto.data.replaceAll('/', '')}&${gasto.categoria.nome}")
          .delete();
      feedback(true, 'Limite de gasto deletado com sucesso!');
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível excluir o limite de gasto!");
    }
  }

  updateSaldoGasto(Gastos gasto, String valor) async {
    String formatarParaReal(double valor) {
      final formatter = NumberFormat("#,##0.00", "pt_BR");
      return formatter.format(valor);
    }

    String valorGastoFormt =
        gasto.valor.replaceAll('.', '').replaceAll(',', '.');
    double valorGasto = double.parse(valorGastoFormt);

    String valorBaseFormt = valor.replaceAll('.', '').replaceAll(',', '.');
    double valorBase = double.parse(valorBaseFormt);

    double conta = valorGasto + valorBase;
    String result = formatarParaReal(conta);
    print("Novo Valor do limite de gasto: ${result}");

    await db
        .collection('usuarios/${auth.usuario!.uid}/gastos')
        .doc("${gasto.data.replaceAll('/', '')}&${gasto.categoria.nome}")
        .update({
      'valor': result,
    });
    for (var g in _gastos) {
      if (extrairMesEAno(g.data) == extrairMesEAno(gasto.data) &&
          g.categoria.nome == gasto.categoria.nome) {
        g.valor = result;
        break;
      }
    }
    notifyListeners();
  }

  List<Gastos> get gastos => _gastos;
}
