import 'package:financas_pessoais/model/bancos.dart';

class RepositoryBanco {
  final List<Banco> _bancos = [
    Banco(nome: "Amazon", img: "assets/bancos/amazon.jpg"),
    Banco(nome: "Amazonia", img: "assets/bancos/amazonia.png"),
    Banco(nome: "Banco do Nordeste", img: "assets/bancos/banco_nordeste.png"),
    Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png"),
    Banco(nome: "Banco BMG", img: "assets/bancos/bmg.png"),
    Banco(nome: "Bradesco", img: "assets/bancos/bradesco.jpg"),
    Banco(nome: "BTG Pactual", img: "assets/bancos/btg.png"),
    Banco(nome: "Banco BV", img: "assets/bancos/bv.jpg"),
    Banco(nome: "Caixa", img: "assets/bancos/caixa.jpg"),
    Banco(nome: "Hipercard", img: "assets/bancos/hipercard.png"),
    Banco(nome: "Inter", img: "assets/bancos/inter1.png"),
    Banco(nome: "Itaú", img: "assets/bancos/itau.jpg"),
    Banco(nome: "Banco Modal", img: "assets/bancos/modal.jpg"),
    Banco(nome: "Next", img: "assets/bancos/next.jpg"),
    Banco(nome: "Nubank", img: "assets/bancos/nubank.png"),
    Banco(nome: "Banco Original", img: "assets/bancos/original.jpg"),
    Banco(nome: "Banco PAN", img: "assets/bancos/pan.png"),
    Banco(nome: "Paypal", img: "assets/bancos/paypal.png"),
    Banco(nome: "Safra", img: "assets/bancos/safra.png"),
    Banco(nome: "Santander", img: "assets/bancos/santander.png"),
  ];

  List<Banco> get bancos => _bancos;
}
