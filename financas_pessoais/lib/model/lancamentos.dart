import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/conta.dart';

class Lancamentos {
  String valor;
  String descricao;
  String data;
  bool eDespesa;
  Categorias categoria;
  Conta? conta;
  Cartao? cartao;

  Lancamentos(
      {required this.valor,
      required this.descricao,
      required this.data,
      required this.eDespesa,
      required this.categoria,
      required this.conta,
      required this.cartao});
}
