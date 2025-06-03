import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesCartaoPage extends StatefulWidget {
  final Cartao cartao;
  const DetalhesCartaoPage({super.key, required this.cartao});

  @override
  State<DetalhesCartaoPage> createState() => _DetalhesCartaoPageState();
}

class _DetalhesCartaoPageState extends State<DetalhesCartaoPage> {
  late RepositoryFatura repositoryFatura;
  late List<Fatura> listaFaturas;
  PageController pageController = PageController();
  int currentIndex = 0;
  List<String> datas = [];

  void recuperaDatasLancamentos() {
    if (listaFaturas.isNotEmpty) {
      if (listaFaturas[currentIndex].lancamentos.isNotEmpty) {
        for (var lancamento in listaFaturas[currentIndex].lancamentos) {
          if (!datas.contains(lancamento.data)) {
            datas.add(lancamento.data);
          }
        }
      }
    }
  }

  void ordenaDatasLancamentos() {
    if (datas.isNotEmpty) {
      datas.sort((a, b) {
        // Converte as strings para DateTime
        List<String> partesA = a.split('/');
        List<String> partesB = b.split('/');

        DateTime dataA = DateTime(
          int.parse(partesA[2]), // ano
          int.parse(partesA[1]), // mês
          int.parse(partesA[0]), // dia
        );

        DateTime dataB = DateTime(
          int.parse(partesB[2]),
          int.parse(partesB[1]),
          int.parse(partesB[0]),
        );

        // Ordena de mais recente para mais antiga
        return dataB.compareTo(dataA);
      });
    }
  }

  List<Fatura> filtrarFaturasPorCartao(Cartao cartao) {
    List<Fatura> faturasFiltradas = [];

    for (var fatura in repositoryFatura.faturas) {
      if (fatura.cartao.nome == widget.cartao.nome) {
        faturasFiltradas.add(fatura);
      }
    }
    if (faturasFiltradas.isNotEmpty) {
      ordenarPorDataDecrescente(faturasFiltradas, (f) => f.data);
    }
    return faturasFiltradas;
  }

  void ordenarPorDataDecrescente(
      List<dynamic> lista, String Function(dynamic) getData) {
    lista.sort((a, b) {
      DateTime dataA = _converterParaDateTime(getData(a));
      DateTime dataB = _converterParaDateTime(getData(b));
      return dataB.compareTo(dataA); // Mais recente primeiro
    });
  }

  DateTime _converterParaDateTime(String data) {
    return DateTime.parse(
        "${data.substring(6, 10)}-${data.substring(3, 5)}-${data.substring(0, 2)}");
  }

  String formatarMes(String dataStr) {
    // Converter String "dd/MM/yyyy" para DateTime
    DateTime data = DateTime.parse(
        "${dataStr.substring(6, 10)}-${dataStr.substring(3, 5)}-${dataStr.substring(0, 2)}");

    const List<String> meses = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];

    String mes = meses[data.month - 1];
    int ano = data.year;
    int anoAtual = DateTime.now().year;

    if (ano == anoAtual) {
      return mes;
    } else {
      return "${mes.substring(0, 3)}.$ano";
    }
  }

  String verificarStatus(
      String dataInicioStr, String dataFimStr, bool estaPaga) {
    DateTime now = DateTime.now();
    int anoAtual = now.year;

    // Converte as datas de string para DateTime, assumindo o ano atual
    List<String> partesInicio = dataInicioStr.split('/');
    int diaInicio = int.parse(partesInicio[0]);
    int mesInicio = int.parse(partesInicio[1]);

    List<String> partesFim = dataFimStr.split('/');
    int diaFim = int.parse(partesFim[0]);
    int mesFim = int.parse(partesFim[1]);

    // Cria objetos DateTime
    DateTime dataInicio = DateTime(anoAtual, mesInicio, diaInicio);
    DateTime dataFim = DateTime(anoAtual, mesFim, diaFim);

    // Ajusta para o próximo ano se a data de início for em dezembro e o fim em janeiro, por exemplo
    if (dataFim.isBefore(dataInicio)) {
      // significa que o intervalo passa de um ano para outro
      dataFim = DateTime(anoAtual + 1, mesFim, diaFim);
    }

    // Situação: A data atual está dentro do intervalo
    if (now.isAfter(dataInicio) && now.isBefore(dataFim)) {
      return estaPaga ? "Paga" : "Aberto";
    }
    // Situação: A data atual é igual à data de início ou fim
    if (now.isAtSameMomentAs(dataInicio) || now.isAtSameMomentAs(dataFim)) {
      return estaPaga ? "Paga" : "Aberto";
    }
    // Situação: A data atual passou do intervalo
    if (now.isAfter(dataFim)) {
      return estaPaga ? "Paga" : "Atrasada";
    }
    // Situação: A data atual é antes do início
    return estaPaga ? "Paga" : "Aberto";
  }

  String ajustarDiaParaDataInformada(String diaRecebido, String dataBase) {
    int dia = int.tryParse(diaRecebido) ?? 1;

    // Parse da data recebida
    List<String> partes = dataBase.split('/');
    if (partes.length < 3) {
      throw FormatException("Data inválida. Esperado formato: dd/MM/yyyy");
    }

    int mes = int.tryParse(partes[1]) ?? 1;
    int ano = int.tryParse(partes[2]) ?? DateTime.now().year;

    // Último dia do mês baseado no mês e ano informados
    DateTime ultimoDiaDoMes = DateTime(ano, mes + 1, 0);
    int ultimoDia = ultimoDiaDoMes.day;

    int diaResultado = dia > ultimoDia ? ultimoDia : dia;

    String diaFormatado = diaResultado.toString().padLeft(2, '0');
    String mesFormatado = mes.toString().padLeft(2, '0');

    return "$diaFormatado/$mesFormatado";
  }

  String compararDiasComBase(
      String dia1Str, String dia2Str, String dataBaseStr) {
    int dia1 = int.parse(dia1Str);
    int dia2 = int.parse(dia2Str);

    // Divide a dataBase e extrai dia, mês e ano
    List<String> partesData = dataBaseStr.split('/');
    int diaBase = int.parse(partesData[0]);
    int mesBase = int.parse(partesData[1]);
    int anoBase = int.parse(partesData[2]);
    print(diaBase);

    int mesRetorno = mesBase;
    int anoRetorno = anoBase;
    print(anoRetorno);

    // Se dia1 > dia2, dia2 pertence ao próximo mês
    if (dia1 > dia2) {
      mesRetorno = mesBase + 1;
      if (mesRetorno > 12) {
        mesRetorno = 1; // Ajusta para Janeiro
        anoRetorno += 1; // Ajusta o ano
      }
    }

    // Formata dia e mês com dois dígitos
    String diaFormatado = dia2.toString().padLeft(2, '0');
    String mesFormatado = mesRetorno.toString().padLeft(2, '0');

    return "$diaFormatado/$mesFormatado";
  }

  String formatarDiaComMesAtual(String dia) {
    int mesAtual = DateTime.now().month;

    String mesFormatado = mesAtual.toString().padLeft(2, '0');

    return "$dia/$mesFormatado";
  }

  String formatarParaReal(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return formatter.format(valor);
  }

  double converterStringParaDouble(String valor) {
    String semSeparadorMilhar = valor.replaceAll('.', '');
    String valorComPonto = semSeparadorMilhar.replaceAll(',', '.');

    return double.parse(valorComPonto);
  }

  String calcularGastoNoMes() {
    double valorTotalLancamento = 0;
    double valorTotalPagamento = 0;

    for (var lancamento in listaFaturas[currentIndex].lancamentos) {
      String valorFormatado =
          lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      if (lancamento.eDespesa) {
        valorTotalLancamento += (valor * (-1));
      } else {
        valorTotalLancamento += valor;
      }
    }
    for (var pagamento in listaFaturas[currentIndex].pagamentos) {
      String valorFormatado =
          pagamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      valorTotalPagamento += moduloNum(valor);
    }
    if (valorTotalPagamento != valorTotalLancamento) {
      print("Falta pagar: ${valorTotalLancamento + valorTotalPagamento}");
    }
    if (listaFaturas[currentIndex].foiPago) {
      return formatarParaReal(valorTotalLancamento);
    }
    return formatarParaReal(valorTotalLancamento + valorTotalPagamento);
  }

  String calcValorPagar() {
    double valorTotalLancamento = 0;
    double valorTotalPagamento = 0;

    for (var lancamento in listaFaturas[currentIndex].lancamentos) {
      String valorFormatado =
          lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      if (lancamento.eDespesa) {
        valorTotalLancamento += (valor * (-1));
      } else {
        valorTotalLancamento += valor;
      }
    }
    for (var pagamento in listaFaturas[currentIndex].pagamentos) {
      String valorFormatado =
          pagamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      if (listaFaturas[currentIndex].foiPago) {
        valorTotalPagamento += valor;
      } else {
        valorTotalPagamento += moduloNum(valor);
      }
    }
    if (valorTotalPagamento != valorTotalLancamento) {
      print("Falta pagar: ${valorTotalLancamento + valorTotalPagamento}");
    }
    if (listaFaturas[currentIndex].foiPago) {
      return formatarParaReal(valorTotalPagamento);
    }
    return formatarParaReal(valorTotalLancamento + valorTotalPagamento);
  }

  bool hasBotaoPagar() {
    double valorTotalLancamento = 0;
    double valorTotalPagamento = 0;

    for (var lancamento in listaFaturas[currentIndex].lancamentos) {
      String valorFormatado =
          lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      if (lancamento.eDespesa) {
        valorTotalLancamento += (valor * (-1));
      } else {
        valorTotalLancamento += valor;
      }
    }
    for (var pagamento in listaFaturas[currentIndex].pagamentos) {
      String valorFormatado =
          pagamento.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      if (listaFaturas[currentIndex].foiPago) {
        valorTotalPagamento += valor;
      } else {
        valorTotalPagamento += moduloNum(valor);
      }
    }
    if (valorTotalPagamento != valorTotalLancamento) {
      print("Falta pagar: ${valorTotalLancamento + valorTotalPagamento}");
    }

    return valorTotalPagamento != valorTotalLancamento ? true : false;
  }

  bool possuiSinalNegativo(String valor) {
    return valor.contains('-');
  }

  Color statusFatura() {
    String status = verificarStatus(
        ajustarDiaParaDataInformada(
            widget.cartao.diaFechamento, listaFaturas[currentIndex].data),
        compararDiasComBase(widget.cartao.diaFechamento,
            widget.cartao.diaVencimento, listaFaturas[currentIndex].data),
        listaFaturas[currentIndex].foiPago);
    if (status == "Aberto") {
      return Colors.grey;
    } else if (status == "Paga") {
      return Colors.green;
    }
    return Colors.red;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repositoryFatura = RepositoryFatura();
    listaFaturas = filtrarFaturasPorCartao(widget.cartao);
    datas = [];
    recuperaDatasLancamentos();
    ordenaDatasLancamentos();

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Detalhes da fatura",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/homeController');
            },
          ),
        ),
        body: listaFaturas.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.grey.shade700,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Não exite faturas para este cartão!",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: AppColors.backgroundClaro,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (listaFaturas.length > (currentIndex + 1)) {
                                  currentIndex++;
                                  pageController.animateToPage(
                                    currentIndex,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  print("Ação inválida");
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: listaFaturas.length > (currentIndex + 1)
                                    ? AppColors.azulPrimario
                                    : Colors.grey,
                              )),
                          Container(
                            height: 50,
                            width: 200,
                            child: PageView.builder(
                                reverse: true,
                                controller: pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                itemCount: listaFaturas.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                      child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 7),
                                      child: Text(
                                        formatarMes(listaFaturas[index].data),
                                        style: TextStyle(
                                            color: AppColors.azulPrimario,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.azulPrimario),
                                      color: AppColors.backgroundClaro,
                                    ),
                                  ));
                                }),
                          ),
                          IconButton(
                              onPressed: () {
                                if (currentIndex > 0) {
                                  currentIndex--;
                                  pageController.animateToPage(
                                    currentIndex,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  print("Ação inválida");
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: currentIndex > 0
                                    ? AppColors.azulPrimario
                                    : Colors.grey,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: AssetImage(
                                                  widget.cartao.icone.img),
                                              backgroundColor: null,
                                              child: null,
                                            )),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: statusFatura(),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              verificarStatus(
                                                  ajustarDiaParaDataInformada(
                                                      widget
                                                          .cartao.diaFechamento,
                                                      listaFaturas[currentIndex]
                                                          .data),
                                                  compararDiasComBase(
                                                      widget
                                                          .cartao.diaFechamento,
                                                      widget
                                                          .cartao.diaVencimento,
                                                      listaFaturas[currentIndex]
                                                          .data),
                                                  listaFaturas[currentIndex]
                                                      .foiPago),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.cartao.nome}",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Fecha em",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      ajustarDiaParaDataInformada(
                                                          widget.cartao
                                                              .diaFechamento,
                                                          listaFaturas[
                                                                  currentIndex]
                                                              .data),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Vence em",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        compararDiasComBase(
                                                            widget.cartao
                                                                .diaFechamento,
                                                            widget.cartao
                                                                .diaVencimento,
                                                            listaFaturas[
                                                                    currentIndex]
                                                                .data),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Gasto no mês",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      calcularGastoNoMes(),
                                                      style: TextStyle(
                                                          color: possuiSinalNegativo(
                                                                  calcularGastoNoMes())
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        listaFaturas[
                                                                    currentIndex]
                                                                .foiPago
                                                            ? "Valor pago"
                                                            : "Valor a pagar",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        calcValorPagar(),
                                                        style: TextStyle(
                                                            color: possuiSinalNegativo(
                                                                    calcValorPagar())
                                                                ? Colors.red
                                                                : Colors.green,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: listaFaturas[currentIndex]
                                        .pagamentos
                                        .isNotEmpty
                                    ? [
                                        for (int i = 0;
                                            i <
                                                listaFaturas[currentIndex]
                                                    .pagamentos
                                                    .length;
                                            i++)
                                          cardPagamentos(i),
                                      ]
                                    : [],
                              ),
                            ),
                            Column(
                              children: hasBotaoPagar()
                                  ? [botaoPagar(), Divider()]
                                  : [Divider()],
                            ),
                            Column(
                              children: [
                                if (listaFaturas[currentIndex]
                                    .lancamentos
                                    .isNotEmpty)
                                  for (int i = 0; i < datas.length; i++)
                                    cardDatas(i),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget cardDatas(int i) {
    double converterValor(String valorStr, bool negativo) {
      String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
      double valor = double.parse(valorLimpo);
      return negativo ? -valor : valor;
    }

    Color corPagamento(double valor) {
      return valor >= 0 ? AppColors.azulPrimario : Colors.red;
    }

    Widget cardLancamentos(Lancamentos lancamento) {
      bool match = false;
      if (lancamento.data == datas[i]) {
        match = true;
      }

      return match
          ? ListTile(
              leading: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircleAvatar(
                      radius: 15,
                      backgroundColor: lancamento.categoria.cor,
                      child: Icon(
                        lancamento.categoria.icon,
                        color: Colors.white,
                      ))),
              title: Text(
                lancamento.descricao,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800),
              ),
              trailing: Text(
                formatarParaReal(
                    converterValor(lancamento.valor, lancamento.eDespesa)),
                style: TextStyle(
                    color: corPagamento(
                        converterValor(lancamento.valor, lancamento.eDespesa)),
                    fontSize: 13),
              ),
            )
          : Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                datas[i],
                style: TextStyle(
                    color: Colors.grey.shade800, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        if (listaFaturas[currentIndex].lancamentos.isNotEmpty)
          for (Lancamentos lancamento in listaFaturas[currentIndex].lancamentos)
            cardLancamentos(lancamento),
      ],
    );
  }

  double moduloNum(double valor) {
    if (valor >= 0) {
      return valor;
    }
    return valor * (-1);
  }

  Widget botaoPagar() {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: BorderSide(
                color: Colors.green,
                width: 1,
              ),
            ),
          ),
          onPressed: () {
            print("Pagar Fatura");
            //Navigator.pushNamed(context, '/gerenciaCartao');
          },
          child: Text(
            'Pagar Fatura',
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget cardPagamentos(int i) {
    String valorFormatado = listaFaturas[currentIndex]
        .pagamentos[i]
        .valor
        .replaceAll(".", "")
        .replaceAll(",", ".");
    double valor = double.parse(valorFormatado);

    Color corPagamento() {
      return valor >= 0 ? AppColors.azulPrimario : Colors.red;
    }

    return ListTile(
      leading: SizedBox(
          width: 25,
          height: 25,
          child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ))),
      title: Text(
        "Pagamento Recebido",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800),
      ),
      subtitle: Text(
        "em ${listaFaturas[currentIndex].pagamentos[i].data}",
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 12),
      ),
      trailing: Text(
        formatarParaReal(valor),
        style: TextStyle(color: corPagamento(), fontSize: 13),
      ),
    );
  }
}

/* 
ListTile(
              leading: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircleAvatar(
                      radius: 15,
                      backgroundColor: listaFaturas[currentIndex]
                          .lancamentos[i]
                          .categoria
                          .cor,
                      child: Icon(
                        listaFaturas[currentIndex]
                            .lancamentos[i]
                            .categoria
                            .icon,
                        color: Colors.white,
                      ))),
              title: Text(
                listaFaturas[currentIndex].lancamentos[i].descricao,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                formatarParaReal(converterValor(
                    listaFaturas[currentIndex].lancamentos[i].valor,
                    listaFaturas[currentIndex].lancamentos[i].eDespesa)),
                style: TextStyle(
                    color: corPagamento(converterValor(
                        listaFaturas[currentIndex].lancamentos[i].valor,
                        listaFaturas[currentIndex].lancamentos[i].eDespesa)),
                    fontSize: 13),
              ),
            )
*/

/*
  String calcularPagoNoMes() {
    List<Pagamentos> pagamentos = listaFaturas[currentIndex].pagamentos;
    double totalPago = 0;
    if (pagamentos.isNotEmpty) {
      for (var pagamento in pagamentos) {
        double valorPago = converterStringParaDouble(pagamento.valor);
        totalPago += valorPago;
      }
    }
    return formatarParaReal(totalPago);
  }*/

  /*
  String calcularGastoNoMes() {
    List<Lancamentos> lancamentos = listaFaturas[currentIndex].lancamentos;
    double totalGasto = 0;
    if (lancamentos.isNotEmpty) {
      for (var lancamento in lancamentos) {
        double valorLancamento = converterStringParaDouble(lancamento.valor);
        if (lancamento.eDespesa) {
          totalGasto += (valorLancamento * -1);
        } else {
          totalGasto += valorLancamento;
        }
      }
    }
    return formatarParaReal(totalGasto);
  }*/