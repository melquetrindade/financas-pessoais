import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/lancamentos.dart';

class Pagamentos {
  String valor;
  String data;

  Pagamentos({required this.data, required this.valor});
}

class Fatura {
  List<Lancamentos> lancamentos;
  Cartao cartao;
  List<Pagamentos> pagamentos;
  String data;
  bool foiPago;

  Fatura(
      {required this.lancamentos,
      required this.cartao,
      required this.pagamentos,
      required this.data,
      required this.foiPago});
}
