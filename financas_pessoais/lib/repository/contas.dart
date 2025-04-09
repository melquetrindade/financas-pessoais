import 'package:financas_pessoais/model/conta.dart';

class RepositoryContas {
  final List<Conta> _contas = [
    Conta(nome: "Banco do Brasil", icone: "assets/bb.png", saldo: "1.567,90"),
    Conta(nome: "Caixa", icone: "assets/caixa.jpg", saldo: "5.633,90"),
    Conta(nome: "Banco PAN", icone: "assets/pan.png", saldo: "10.000,00"),
  ];

  List<Conta> get contas => _contas;
}
