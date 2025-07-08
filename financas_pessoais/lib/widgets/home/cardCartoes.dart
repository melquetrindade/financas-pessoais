import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/pages/detalhesCartaoPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Cardcartoes extends StatefulWidget {
  final List<Cartao> listCartao;
  final List<Fatura> listaFatura;
  final bool isLoading;
  const Cardcartoes(
      {super.key,
      required this.listCartao,
      required this.listaFatura,
      required this.isLoading});

  @override
  State<Cardcartoes> createState() => _CardcartoesState();
}

class _CardcartoesState extends State<Cardcartoes> {
  bool showSaldo = true;
  double fatura = 0;

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

  void calcFatura() {
    DateTime hoje = DateTime.now();

    for (var cartao in widget.listCartao) {
      final faturasCartao = widget.listaFatura.where((fatura) =>
          fatura.cartao.nome == cartao.nome &&
          _converterStringParaDateTime(fatura.data).month == hoje.month &&
          _converterStringParaDateTime(fatura.data).year == hoje.year);

      if (faturasCartao.isNotEmpty) {
        final faturaAtual = faturasCartao.first;

        double faturaDespesaTotal = 0;
        double faturaReceitaTotal = 0;
        double faturaPagamento = 0;

        for (var lancamento in faturaAtual.lancamentos) {
          String valorStr =
              lancamento.valor.replaceAll('.', '').replaceAll(',', '.');
          double valor = double.parse(valorStr);
          if (lancamento.eDespesa) {
            faturaDespesaTotal += valor * -1;
          } else {
            faturaReceitaTotal += valor;
          }
        }

        for (var pagamento in faturaAtual.pagamentos) {
          String valorStr =
              pagamento.valor.replaceAll('.', '').replaceAll(',', '.');
          faturaPagamento += double.parse(valorStr);
        }

        double calcFaturaAtual(
            double fatDespesa, double fatReceita, double fatPagamento) {
          double conta = fatDespesa + fatReceita + fatPagamento;
          return conta > 0 ? 0 : conta;
        }

        fatura += calcFaturaAtual(
          faturaDespesaTotal,
          faturaReceitaTotal,
          faturaPagamento >= 0 ? faturaPagamento : -faturaPagamento,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fatura = 0;
    calcFatura();

    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Todas as faturas",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        showSaldo ? formatarParaReal(fatura) : "R\$ ---",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: showSaldo
                                ? fatura < 0
                                    ? Colors.red
                                    : AppColors.azulPrimario
                                : Colors.black54),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSaldo = !showSaldo;
                      });
                    },
                    icon: Icon(showSaldo
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Divider(
                  color: AppColors.azulPrimario,
                  thickness: 1,
                  height: 20,
                ),
              ),
              Text(
                "Meus cartões",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              Column(children: [
                if (widget.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: SizedBox(
                        width: 34,
                        height: 34,
                        child: CircularProgressIndicator(
                          color: AppColors.azulPrimario,
                        ),
                      ),
                    ),
                  )
                else if (widget.listCartao.isNotEmpty)
                  ...List.generate(
                      widget.listCartao.length, (i) => cardCartao(i))
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Icon(
                            Icons.help_outline_sharp,
                            color: Colors.grey.shade700,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Você não tem cartão cadastrado",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(
                          color: AppColors.azulPrimario,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/gerenciaCartao');
                    },
                    child: Text(
                      widget.listCartao.length != 0
                          ? 'Gerenciar cartões'
                          : 'Criar cartão',
                      style: TextStyle(
                          color: AppColors.azulPrimario, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget cardCartao(int i) {
    List<Fatura> faturasFiltradas = [];
    double faturaDespesaTotal = 0;
    double faturaReceitaTotal = 0;
    double disponivelTotal = 0;
    double faturaPagamento = 0;
    DateTime hoje = DateTime.now();

    for (var fatura in widget.listaFatura) {
      if (fatura.cartao.nome == widget.listCartao[i].nome) {
        DateTime dataFatura = _converterStringParaDateTime(fatura.data);

        if (dataFatura.month == hoje.month && dataFatura.year == hoje.year) {
          faturasFiltradas.add(fatura);
        }
      }
    }

    void calcFaturaTotal() {
      if (faturasFiltradas[0].lancamentos.isNotEmpty) {
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
        double conta = faturaReceitaTotal +
            faturaDespesaTotal +
            moduloNum(faturaPagamento);
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
      return (faturaReceitaTotal +
                  faturaDespesaTotal +
                  moduloNum(faturaPagamento)) >=
              0
          ? AppColors.azulPrimario
          : Colors.red;
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

    if (faturasFiltradas.length != 0) {
      calcFaturaTotal();
      calcFaturaPagamento();
      calcDisponivelTotal();
    } else {
      String valorFormatado =
          widget.listCartao[i].limite.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      disponivelTotal = valor;
    }

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: widget.listCartao[i].icone.img == "Cartão"
                    ? AppColors.azulPrimario
                    : null,
                backgroundImage: widget.listCartao[i].icone.img == "Cartão"
                    ? null
                    : AssetImage(widget.listCartao[i].icone.img),
                child: widget.listCartao[i].icone.img == "Cartão"
                    ? Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      )
                    : null,
              )),
          title: Text(widget.listCartao[i].nome),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => (DetalhesCartaoPage(
                          cartao: widget.listCartao[i],
                        ))));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
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
                        Text(
                          showSaldo
                              ? "${formatarParaReal(disponivelTotal)}"
                              : "R\$ ---",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: showSaldo ? Colors.black : Colors.black54),
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
                            showSaldo
                                ? "${formatarParaReal(calcFaturaAtual(faturaDespesaTotal, faturaReceitaTotal, moduloNum(faturaPagamento)))}"
                                : "R\$ ---",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    showSaldo ? corFatura() : Colors.black45))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.azulPrimario,
          thickness: 1,
        )
      ],
    );
  }
}

/*
    if (calcFaturaAtual(faturaDespesaTotal, faturaReceitaTotal,
            moduloNum(faturaPagamento)) !=
        0) {
      print("entrou no if");
      setState(() {
        fatura += calcFaturaAtual(
            faturaDespesaTotal, faturaReceitaTotal, moduloNum(faturaPagamento));
      });
    }*/

    //print("Fatura: ${calcFaturaAtual(faturaDespesaTotal, faturaReceitaTotal, moduloNum(faturaPagamento))}");