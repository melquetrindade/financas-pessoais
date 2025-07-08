import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas_pessoais/databases/db_firestore.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';
import '../model/bancos.dart';

class RepositoryLancamentos extends ChangeNotifier {
  List<Lancamentos> _lancamentos = [];
  late FirebaseFirestore db;
  late AuthService auth;
  bool isLoading = true;

  RepositoryLancamentos({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readLancamentos();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  notifica() {
    notifyListeners();
  }

  _readLancamentos() async {
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

    if (auth.usuario != null && _lancamentos.isEmpty) {
      final snapshot = await db
          .collection('usuarios/${auth.usuario!.uid}/lancamentos')
          .get();
      snapshot.docs.forEach((item) {
        _lancamentos.add(Lancamentos(
            valor: item['valor'],
            descricao: item['descricao'],
            data: item['data'],
            eDespesa: item['eDespesa'],
            categoria: Categorias(nome: item['categoria']['nome'],cor: extrairCor(item['categoria']['cor']),icon: converterUnicodeParaIcone(item['categoria']['icon'])),
            conta: item['conta'] != null
                ? Conta(
                    nome: item['conta']['nome'],
                    banco: Banco(
                        nome: item['conta']['banco']['nome'],
                        img: item['conta']['banco']['img']),
                    saldo: item['conta']['saldo'])
                : null,
            cartao: item['cartao'] != null
                ? Cartao(
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
                    ))
                : null
                ));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  saveLancamento(Lancamentos lancamento, Function feedback) async {
    try {
      _lancamentos.add(lancamento);
      final qtd = await db
          .collection('usuarios/${auth.usuario!.uid}/lancamentos')
          .get();
      await db
          .collection('usuarios/${auth.usuario!.uid}/lancamentos')
          .doc((qtd.size + 1).toString())
          .set({
        'valor': lancamento.valor,
        'descricao': lancamento.descricao,
        'data': lancamento.data,
        'eDespesa': lancamento.eDespesa,
        'categoria': {
          'nome': lancamento.categoria.nome,
          'cor': '${lancamento.categoria.cor}',
          'icon': '${lancamento.categoria.icon}',
        },
        'conta': lancamento.conta != null
            ? {
                'nome': lancamento.conta!.nome,
                'saldo': lancamento.conta!.saldo,
                'banco': {
                  'nome': lancamento.conta!.banco.nome,
                  'img': lancamento.conta!.banco.img
                }
              }
            : null,
        'cartao': lancamento.cartao != null
            ? {
                'nome': lancamento.cartao!.nome,
                'icone': {
                  'nome': lancamento.cartao!.icone.nome,
                  'img': lancamento.cartao!.icone.img
                },
                'limite': lancamento.cartao!.limite,
                'diaFechamento': lancamento.cartao!.diaFechamento,
                'diaVencimento': lancamento.cartao!.diaVencimento,
                'conta': {
                  'nome': lancamento.cartao!.conta.nome,
                  'saldo': lancamento.cartao!.conta.saldo,
                  'banco': {
                    'nome': lancamento.cartao!.conta.banco.nome,
                    'img': lancamento.cartao!.conta.banco.img
                  }
                }
              }
            : null
      });
      feedback(true, 'Lançamento criado com sucesso!');
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      throw AuthException("Erro, não foi possível criar o lancamento!");
    }
  }

  List<Lancamentos> get lancamentos => _lancamentos;
}

/*
print("Lancamento:");
        print("\t\tÉ despesa: ${item['eDespesa']}");
        print("\t\tValor: ${item['valor']}");
        print("\t\tDescrição: ${item['descricao']}");
        print("\t\tData: ${item['data']}");
        print("\t\tCategoria: ${item['categoria']['nome']}");
        print("\t\t${item['conta'] == null ? 'Cartão' : 'Conta'}: ${item['conta'] == null ? item['cartao']['nome'] : item['conta']['nome']}");
*/


/* 
final List<Lancamentos> _lancamentos = [
    Lancamentos(
      valor: "200,00", 
      descricao: "Controle do PS4", 
      data: "02/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "150,00", 
      descricao: "Compra do Red Dead", 
      data: "23/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "50,00", 
      descricao: "Janta", 
      data: "10/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Bares e restaurantes", cor: Colors.deepPurple.shade800, icon: Icons.wine_bar), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco PAN",
        icone: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png"),
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "29",
        conta: Conta(
            nome: "Banco PAN", 
            saldo: "10.000,00",
            banco: Banco(img: "assets/bancos/pan.png", nome: "Banco PAN")
        )),
    ),
    Lancamentos(
      valor: "150,00", 
      descricao: "Aposta ganha na betano", 
      data: "30/04/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Investimentos", cor: Colors.tealAccent.shade700, icon: Icons.list_sharp), 
      conta: Conta(nome: "Banco do Brasil", saldo: "1.567,90", banco: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png")), 
      cartao: null
    ),
    Lancamentos(
      valor: "20,00", 
      descricao: "Transporte", 
      data: "02/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Transporte", cor: Colors.blue.shade300, icon: Icons.bus_alert_sharp), 
      conta: Conta(nome: "Banco PAN", saldo: "10.000,00", banco: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png")), 
      cartao: null
    ),
    Lancamentos(
      valor: "500,00", 
      descricao: "Aluguel", 
      data: "02/05/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Outras Receitas", cor: Colors.teal.shade700, icon: Icons.show_chart_sharp), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "85,00",
      descricao: "Fifa 25",
      data: "23/05/2025",
      eDespesa: true,
      categoria: Categorias(
          nome: "Compras ",
          cor: Colors.pink,
          icon: Icons.shopping_bag_outlined),
      conta: null,
      cartao: Cartao(
          nome: "Banco do Brasil",
          icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
          limite: "1.000,00",
          diaFechamento: "01",
          diaVencimento: "30",
          conta: Conta(
              nome: "Banco do Brasil",
              saldo: "1.567,90",
              banco:
                  Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
    ),
    Lancamentos(
      valor: "75,00", 
      descricao: "Almoço do domingo", 
      data: "10/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant), 
      conta: null, 
      cartao: Cartao(
        nome: "Next",
        icone: Banco(nome: "Cartão", img: "Cartão"),
        limite: "500,00",
        diaFechamento: "08",
        diaVencimento: "15",
        conta:
          Conta(
            nome: "Next",
            saldo: "2.003,90",
            banco: Banco(img: "assets/bancos/next.jpg", nome: "Next")
          )),
    ),
    Lancamentos(
      valor: "1.600,00", 
      descricao: "Salário do mês de maio", 
      data: "31/05/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Salário", cor: Colors.tealAccent.shade400, icon: Icons.star_rounded), 
      conta: Conta(nome: "Poupança", saldo: "8.500,00", banco: Banco(nome: "Cofrinho", img: "Cofrinho")),
      cartao: null
    ),
    Lancamentos(
      valor: "100,00", 
      descricao: "Compra de Fone", 
      data: "23/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil")  
        )),
    ),
  ];
*/