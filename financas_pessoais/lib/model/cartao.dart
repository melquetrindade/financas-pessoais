import 'package:financas_pessoais/model/conta.dart';

class Cartao {
  String nome;
  String icone;
  String limite;
  String diaFechamento;
  String diaVencimento;
  Conta conta;

  Cartao(
      {required this.nome,
      required this.icone,
      required this.limite,
      required this.diaFechamento,
      required this.diaVencimento,
      required this.conta});
}
