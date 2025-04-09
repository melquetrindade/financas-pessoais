import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';

class RepositoryCartao {
  final List<Cartao> _cartoes = [
    Cartao(
        nome: "Banco do Brasil",
        icone: "assets/bb.png",
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
            nome: "Banco do Brasil",
            icone: "assets/bb.png",
            saldo: "1.567,90")),
    Cartao(
        nome: "Banco PAN",
        icone: "assets/pan.png",
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "29",
        conta: Conta(
            nome: "Banco PAN", icone: "assets/pan.png", saldo: "10.000,00")),
    Cartao(
        nome: "Caixa",
        icone: "assets/caixa.jpg",
        limite: "1.500,00",
        diaFechamento: "03",
        diaVencimento: "31",
        conta:
            Conta(nome: "Caixa", icone: "assets/caixa.jpg", saldo: "5.633,90")),
  ];

  List<Cartao> get cartoes => _cartoes;
}
