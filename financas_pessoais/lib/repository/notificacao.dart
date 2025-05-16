import 'package:financas_pessoais/model/notificacao.dart';

class RepositoryNotificacao {
  final List<Notificacao> _listNotificacoes = [
    Notificacao(
      titulo: "Limite de gastos", 
      body: "Você atingiu o seu limite de gastos com alimentação este mês"
    ),
    Notificacao(
      titulo: "Fatura do cartão", 
      body: "Lembre-se de pagar a fatura do cartão do Nubank deste mês"
    ),
    Notificacao(
      titulo: "Limite de gastos", 
      body: "Parabêns! Você atingiu sua meta de gastos com compras este mês"
    ),
  ];

  List<Notificacao> get notificacoes => _listNotificacoes;
}
