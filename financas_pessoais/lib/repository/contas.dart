import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/conta.dart';

class RepositoryContas {
  final List<Conta> _contas = [
    Conta(nome: "Banco do Brasil", saldo: "1.567,90", banco: Banco(nome: "Banco do Brasil", img: "assets/bancos/bb.png")),
    Conta(nome: "Caixa", saldo: "5.633,90", banco: Banco(nome: "Caixa", img: "assets/bancos/caixa.jpg")),
    Conta(nome: "Banco PAN", saldo: "10.000,00", banco: Banco(nome: "Banco PAN", img: "assets/bancos/pan.png")),
    Conta(nome: "Poupança", saldo: "8.500,00", banco: Banco(nome: "Cofrinho", img: "Cofrinho")),
    Conta(nome: "Next", saldo: "2.003,90", banco: Banco(nome: "Next", img: "assets/bancos/next.jpg"))
  ];

  List<Conta> get contas => _contas;
}
