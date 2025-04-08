import 'package:financas_pessoais/model/bancos.dart';

class RepositoryBanco {
  final List<Banco> _bancos = [
    Banco(nome: "Amazon", img: "assets/amazon.jpg"),
    Banco(nome: "Amazonia", img: "assets/amazonia.png"),
    Banco(nome: "Banco do Nordeste", img: "assets/banco_nordeste.png"),
    Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
    Banco(nome: "Banco BMG", img: "assets/bmg.png"),
    Banco(nome: "Bradesco", img: "assets/bradesco.jpg"),
    Banco(nome: "BTG Pactual", img: "assets/btg.png"),
    Banco(nome: "Banco BV", img: "assets/bv.jpg"),
    Banco(nome: "Caixa", img: "assets/caixa.jpg"),
    Banco(nome: "Hipercard", img: "assets/hipercard.png"),
    Banco(nome: "Inter", img: "assets/inter.jpg"),
    Banco(nome: "Itaú", img: "assets/itau.jpg"),
    Banco(nome: "Banco Modal", img: "assets/modal.jpg"),
    Banco(nome: "Next", img: "assets/next.jpg"),
    Banco(nome: "Nubank", img: "assets/nubank.png"),
    Banco(nome: "Banco Original", img: "assets/original.jpg"),
    Banco(nome: "Banco PAN", img: "assets/pan.png"),
    Banco(nome: "Paypal", img: "assets/paypal.png"),
    Banco(nome: "Safra", img: "assets/safra.png"),
    Banco(nome: "Santander", img: "assets/santander.png"),
  ];

  List<Banco> get bancos => _bancos;
}
