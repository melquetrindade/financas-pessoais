import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/conta.dart';

class Cartao {
  String nome;
  Banco icone;
  String limite;
  String diaFechamento;
  String diaVencimento;
  String fatura;
  Conta conta;

  Cartao(
      {required this.nome,
      required this.icone,
      required this.limite,
      required this.diaFechamento,
      required this.diaVencimento,
      required this.fatura,
      required this.conta});
}
