import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/pages/gerenciarCartao/editarCartao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardGerenciaCartao extends StatefulWidget {
  final List<Cartao> listCartao;
  final List<Fatura> listaFatura;
  const CardGerenciaCartao(
      {super.key, required this.listCartao, required this.listaFatura});

  @override
  State<CardGerenciaCartao> createState() => _CardGerenciaCartaoState();
}

class _CardGerenciaCartaoState extends State<CardGerenciaCartao> {
  DateTime _converterStringParaDateTime(String data) {
    List<String> partes = data.split('/');
    int dia = int.parse(partes[0]);
    int mes = int.parse(partes[1]);
    int ano = int.parse(partes[2]);

    return DateTime(ano, mes, dia);
  }

  String formatarParaReal(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return formatter.format(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widget.listCartao.length; i++) cardCartao(i),
      ],
    );
  }

  Widget cardCartao(int i) {
    List<Fatura> faturasFiltradas = [];
    double faturaDespesaTotal = 0;
    double faturaReceitaTotal = 0;
    double disponivelTotal = 0;
    double faturaPagamento = 0;

    void filtrarFaturasPorCartaoEMes(Cartao cartao) {
      DateTime hoje = DateTime.now();

      for (var fatura in widget.listaFatura) {
        if (fatura.cartao.nome == cartao.nome) {
          DateTime dataFatura = _converterStringParaDateTime(fatura.data);

          if (dataFatura.month == hoje.month && dataFatura.year == hoje.year) {
            faturasFiltradas.add(fatura);
          }
        }
      }
    }

    void calcFaturaTotal() {
      if(faturasFiltradas[0].lancamentos.isNotEmpty){
        for (var lancamento in faturasFiltradas[0].lancamentos) {
          if (lancamento.eDespesa) {
            String valorFormatado =
                lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
            double fatura = double.parse(valorFormatado);
            faturaDespesaTotal += fatura * -1;
          } else {
            String valorFormatado =
                lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
            double fatura = double.parse(valorFormatado);
            faturaReceitaTotal += fatura;
          }
        }
      }
    }

    double moduloNum(double valor) {
      if (valor >= 0) {
        return valor;
      }
      return valor * (-1);
    }

    void calcDisponivelTotal() {
      if (faturasFiltradas[0].foiPago) {
        String valorFormatado = widget.listCartao[i].limite
            .replaceAll(".", "")
            .replaceAll(",", ".");
        double valor = double.parse(valorFormatado);
        disponivelTotal = valor;
      } else {
        String limiteFormatado = widget.listCartao[i].limite
            .replaceAll(".", "")
            .replaceAll(",", ".");
        double limite = double.parse(limiteFormatado);
        double conta =
            faturaReceitaTotal + faturaDespesaTotal + moduloNum(faturaPagamento);
        if (conta > 0) {
          disponivelTotal += conta + limite;
        } else {
          disponivelTotal = limite + conta;
        }
      }
    }

    double calcFaturaAtual(
        double fatDespesa, double fatReceita, double fatPagamento) {
      double conta = fatDespesa + fatReceita + fatPagamento;
      if (conta > 0) {
        return 0;
      }
      return conta;
    }

    Color corFatura() {
      return (faturaReceitaTotal + faturaDespesaTotal + moduloNum(faturaPagamento)) >= 0 ? AppColors.azulPrimario : Colors.red;
    }

    void calcFaturaPagamento() {
      if (faturasFiltradas[0].pagamentos.isNotEmpty) {
        for (var pagamento in faturasFiltradas[0].pagamentos) {
          String valorFormatado =
              pagamento.valor.replaceAll(".", "").replaceAll(",", ".");
          double valor = double.parse(valorFormatado);
          faturaPagamento += valor;
        }
      }
    }

    filtrarFaturasPorCartaoEMes(widget.listCartao[i]);
    if(faturasFiltradas.length != 0){
      calcFaturaTotal();
      calcFaturaPagamento();
      calcDisponivelTotal();
    } else {
      String valorFormatado = widget.listCartao[i].limite.replaceAll(".", "").replaceAll(",", ".");
          double valor = double.parse(valorFormatado);
      disponivelTotal = valor;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          widget.listCartao[i].icone.img == "Cartão"
                              ? null
                              : AssetImage(widget.listCartao[i].icone.img),
                      backgroundColor:
                          widget.listCartao[i].icone.img == "Cartão"
                              ? AppColors.azulPrimario
                              : null,
                      child: widget.listCartao[i].icone.img == "Cartão"
                          ? Icon(
                              Icons.credit_card,
                              color: Colors.white,
                            )
                          : null,
                    )),
                title: Text(widget.listCartao[i].nome),
                subtitle: Text(
                  "Fecha dia: ${widget.listCartao[i].diaFechamento} - Vence dia: ${widget.listCartao[i].diaVencimento}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditarCartaoPage(
                                    cartao: widget.listCartao[i],
                                  )));
                    },
                    icon: Icon(Icons.edit)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  color: AppColors.azulPrimario,
                  height: 0.3,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Disponível",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800),
                            ),
                            Text(formatarParaReal(disponivelTotal),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Fatura Atual",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800),
                            ),
                            Text(
                              "${formatarParaReal(calcFaturaAtual(faturaDespesaTotal, faturaReceitaTotal, moduloNum(faturaPagamento)))}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: corFatura()),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
