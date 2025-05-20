import 'package:financas_pessoais/model/bancos.dart';

class Conta {
  String nome;
  String saldo;
  Banco banco;

  Conta({required this.nome, required this.banco, required this.saldo});
}
