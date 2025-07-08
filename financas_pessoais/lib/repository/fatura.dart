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

  _readFaturas() async {
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
        .doc(fatura.data.replaceAll('/', ''))
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

  List<Fatura> get faturas => _faturas;
}

/*
cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
            limite: "1.000,00",
            diaFechamento: "01",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "01/03/205", valor: "-185,00")],
        data: "23/02/2025",
        foiPago: true),


final List<Fatura> _faturas = [
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "500,00",
            descricao: "Aluguel",
            data: "02/05/2025",
            eDespesa: false,
            categoria: Categorias(
                nome: "Outras Receitas",
                cor: Colors.teal.shade700,
                icon: Icons.show_chart_sharp),
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
            valor: "100,00",
            descricao: "Compra de Fone",
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
            valor: "585,00",
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
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
            limite: "1.000,00",
            diaFechamento: "01",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "01/03/205", valor: "-185,00")],
        data: "23/02/2025",
        foiPago: true),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "200,00",
            descricao: "Controle do PS4",
            data: "02/12/2024",
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
            valor: "150,00",
            descricao: "Compra do Red Dead",
            data: "23/12/2024",
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
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
            limite: "1.000,00",
            diaFechamento: "01",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "30/04/205", valor: "-350,00")],
        data: "02/12/2024",
        foiPago: true),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "1.000,00",
            descricao: "Console PS4",
            data: "12/07/2024",
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
            valor: "15,00",
            descricao: "Dogão",
            data: "01/07/2024",
            eDespesa: true,
            categoria: Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant),
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
            valor: "500,00",
            descricao: "Venda dos Notebooks",
            data: "01/07/2024",
            eDespesa: false,
            categoria: Categorias(nome: "Outras Receitas", cor: Colors.teal.shade700, icon: Icons.show_chart_sharp),
            conta: null,
            cartao: Cartao(
                nome: "Banco do Brasil",
                icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
                limite: "1.000,00",
                diaFechamento: "31",
                diaVencimento: "30",
                conta: Conta(
                    nome: "Banco do Brasil",
                    saldo: "1.567,90",
                    banco:
                        Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
          ),
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
            limite: "1.000,00",
            diaFechamento: "31",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bancos/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "14/07/2024", valor: "-1.000,00"), /*Pagamentos(data: "14/06/205", valor: "485,00")*/],
        data: "12/07/2024",
        foiPago: false),
      Fatura(
        lancamentos: [
          Lancamentos(
            valor: "500,00",
            descricao: "Aluguel",
            data: "02/02/2025",
            eDespesa: false,
            categoria: Categorias(
                nome: "Outras Receitas",
                cor: Colors.teal.shade700,
                icon: Icons.show_chart_sharp),
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
          )),),
          Lancamentos(
            valor: "100,00",
            descricao: "Compra de Fone",
            data: "23/02/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
              )),),
          Lancamentos(
            valor: "585,00",
            descricao: "Fifa 25",
            data: "23/02/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
        ],
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
        pagamentos: [],
        data: "23/02/2025",
        foiPago: false),
      Fatura(
        lancamentos: [
          Lancamentos(
            valor: "200,00",
            descricao: "Controle do PS4",
            data: "01/06/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
            descricao: "Compra do Red Dead",
            data: "01/06/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
        ],
        cartao: Cartao(
        nome: "Banco PAN",
        icone: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png"),
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "30",
        conta: Conta(
            nome: "Banco PAN", 
            saldo: "10.000,00",
            banco: Banco(img: "assets/bancos/pan.png", nome: "Banco PAN")
        )),
        pagamentos: [Pagamentos(data: "01/06/2025", valor: "-200,00")],
        data: "01/05/2025",
        foiPago: false),
      Fatura(
        lancamentos: [
        Lancamentos(
            valor: "200,00",
            descricao: "Controle do PS4",
            data: "01/07/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
            descricao: "Compra do Red Dead",
            data: "02/07/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
        ],
        cartao: Cartao(
          nome: "Banco PAN",
          icone: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png"),
          limite: "500,00",
          diaFechamento: "30",
          diaVencimento: "30",
          conta: Conta(
              nome: "Banco PAN", 
              saldo: "10.000,00",
              banco: Banco(img: "assets/bancos/pan.png", nome: "Banco PAN")
          )),
        pagamentos: [Pagamentos(data: "01/07/2025", valor: "-200,00")],
        data: "02/07/2025",
        foiPago: false),
  ];

*/
