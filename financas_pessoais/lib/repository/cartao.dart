import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';

class RepositoryCartao {
  final List<Cartao> _cartoes = [
    Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        fatura: "70,00",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil")  
        )),
    Cartao(
        nome: "Banco PAN",
        icone: Banco(nome: "Banco PAN", img: "assets/pan.png"),
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "29",
        fatura: "-100,00",
        conta: Conta(
            nome: "Banco PAN", 
            saldo: "10.000,00",
            banco: Banco(img: "assets/pan.png", nome: "Banco PAN")
        )),
    Cartao(
        nome: "Caixa",
        icone: Banco(nome: "Caixa", img: "assets/caixa.jpg"),
        limite: "1.500,00",
        diaFechamento: "03",
        diaVencimento: "31",
        fatura: "-200,00",
        conta:
          Conta(
            nome: "Caixa", 
            saldo: "5.633,90",
            banco: Banco(img: "assets/caixa.jpg", nome: "Caixa")
        )),
    Cartao(
        nome: "Next",
        icone: Banco(nome: "Cartão", img: "Cartão"),
        limite: "500,00",
        diaFechamento: "08",
        diaVencimento: "15",
        fatura: "0,00",
        conta:
          Conta(
            nome: "Next",
            saldo: "2.003,90",
            banco: Banco(img: "assets/next.jpg", nome: "Next")
          )),
  ];

  List<Cartao> get cartoes => _cartoes;
}
