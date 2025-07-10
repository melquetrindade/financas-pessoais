import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  late RepositoryContas repositoryContas;
  late List<Conta> listaContas;
  late List<Conta> listaContasAtuais;
  late RepositoryLancamentos repositoryLancamentos;
  late List<Lancamentos> listaLancamentos;
  late List<String> datas;
  List<Lancamentos> lancamentosAtuais = [];
  double receita = 0;
  double despesa = 0;
  double maxY = 0;
  double minY = 0;
  PageController pageController = PageController();
  int currentIndex = 0;
  String filtroConta = "todas";

  void mostrarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.93,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: modalCategorias(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  double moduloValor(double valor) {
    return valor < 0 ? -(valor) : valor;
  }

  void setMaximoYX() {
    double receitaAbs = receita.abs();
    double despesaAbs = despesa.abs();

    double maior = receitaAbs > despesaAbs ? receitaAbs : despesaAbs;

    if (maior > 0) {
      double margem = maior * 0.1;
      maxY = maior + margem;
      minY = -(maior + margem);
    } else {
      maxY = 100;
      minY = -100;
    }
  }

  List<String> ordenarMesAno(List<Lancamentos> lancamentos) {
    List<String> datas = [];
    if (lancamentos.isNotEmpty) {
      for (var lancamento in lancamentos) {
        datas.add(lancamento.data);
      }

      final List<DateTime> convertidas = datas.map((d) {
        final partes = d.split('/');
        final mes = int.parse(partes[1]);
        final ano = int.parse(partes[2]);
        return DateTime(ano, mes);
      }).toList();

      convertidas.sort((a, b) => b.compareTo(a));
      final Set<String> jaAdicionados = {};
      final List<String> resultado = [];

      for (final data in convertidas) {
        final String mesAno =
            '${data.month.toString().padLeft(2, '0')}/${data.year}';
        if (jaAdicionados.add(mesAno)) {
          resultado.add(mesAno);
        }
      }
      return resultado;
    }
    return [];
  }

  String formatarMesAno(String mesAno) {
    const List<String> nomesMeses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    final partes = mesAno.split('/');
    final int mes = int.parse(partes[0]);
    final int ano = int.parse(partes[1]);
    final int anoAtual = DateTime.now().year;
    final String nomeMes = nomesMeses[mes - 1];

    if (ano == anoAtual) {
      return nomeMes;
    }

    final String abreviado = nomeMes.substring(0, 3);
    return '$abreviado.$ano';
  }

  List<Lancamentos> filtrarPorMesAno(
      List<Lancamentos> lancamentos) {
    if (lancamentos.isNotEmpty && datas.isNotEmpty) {
      final partesBase = datas[currentIndex].split('/');
      if (partesBase.length != 2) return [];

      final int mesBase = int.tryParse(partesBase[0]) ?? -1;
      final int anoBase = int.tryParse(partesBase[1]) ?? -1;
      if (mesBase < 1 || mesBase > 12 || anoBase < 0) return [];

      return lancamentos.where((l) {
        final partesData = l.data.split('/');
        if (partesData.length != 3) return false;

        final int mesLanc = int.tryParse(partesData[1]) ?? -1;
        final int anoLanc = int.tryParse(partesData[2]) ?? -1;

        return mesLanc == mesBase && anoLanc == anoBase;
      }).toList();
    }
    return [];
  }

  double converterValor(String valorStr, bool negativo) {
    String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
    double valor = double.parse(valorLimpo);
    return negativo ? -valor : valor;
  }

  void calcReceitaDespesa() {
    double receitaAux = 0;
    double despesaAux = 0;
    List<Lancamentos> lancAux = [];
    if (lancamentosAtuais.isNotEmpty) {
      if (filtroConta == "todas") {
        for (var lancamento in lancamentosAtuais) {
          double valor = converterValor(lancamento.valor, lancamento.eDespesa);
          if (valor < 0) {
            despesaAux += valor;
          } else {
            receitaAux += valor;
          }
        }
      } else {
        for (var lancamento in lancamentosAtuais) {
          if (lancamento.conta == null) {
            if (lancamento.cartao!.conta.nome == filtroConta) {
              lancAux.add(lancamento);
            }
          } else {
            if (lancamento.conta!.nome == filtroConta) {
              lancAux.add(lancamento);
            }
          }
        }
        for (var lancamento in lancAux) {
          double valor = converterValor(lancamento.valor, lancamento.eDespesa);
          if (valor < 0) {
            despesaAux += valor;
          } else {
            receitaAux += valor;
          }
        }
      }
    }
    receita = receitaAux;
    despesa = despesaAux;
  }

  String formatarParaReal(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );

    return formatter.format(valor);
  }

  List<Conta> filtraContasAtuais() {
    List<Conta> listaAux = [];
    if (lancamentosAtuais.isNotEmpty) {
      for (var lancamento in lancamentosAtuais) {
        if (lancamento.conta == null) {
          for (var conta in listaContas) {
            if (lancamento.cartao!.conta.nome == conta.nome) {
              if (!listaAux.contains(conta)) {
                listaAux.add(conta);
              }
            }
          }
        } else {
          for (var conta in listaContas) {
            if (lancamento.conta!.nome == conta.nome) {
              if (!listaAux.contains(conta)) {
                listaAux.add(conta);
              }
            }
          }
        }
      }
    }
    return listaAux;
  }

  @override
  Widget build(BuildContext context) {
    repositoryContas = context.watch<RepositoryContas>();
    listaContas = repositoryContas.contas;
    repositoryLancamentos = context.watch<RepositoryLancamentos>();
    listaLancamentos = repositoryLancamentos.lancamentos;
    datas = ordenarMesAno(listaLancamentos);
    lancamentosAtuais = filtrarPorMesAno(listaLancamentos);
  
    listaContasAtuais = filtraContasAtuais();
    calcReceitaDespesa();
    setMaximoYX();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.azulPrimario,
        centerTitle: true,
        title: Text(
          "Limites de gastos",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: listaLancamentos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    "Não existe fluxo de caixa para gerar o relatório",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (datas.length > (currentIndex + 1)) {
                                filtroConta = "todas";
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
                              color: datas.length > (currentIndex + 1)
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
                              itemCount: datas.length,
                              itemBuilder: (context, index) {
                                return Center(
                                    child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 7),
                                    child: Text(
                                      formatarMesAno(datas[index]),
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
                                filtroConta = "todas";
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
                  Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Entradas x Saídas",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                mostrarModal(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Todas as Contas",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.center,
                                        maxY: maxY,
                                        minY: minY,
                                        baselineY: 0,
                                        barTouchData:
                                            BarTouchData(enabled: false),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine:
                                              false, // Oculta as linhas verticais
                                          drawHorizontalLine: true,
                                          getDrawingHorizontalLine: (value) {
                                            if (value == 0) {
                                              return FlLine(
                                                color: Colors.grey.shade400,
                                                strokeWidth: 1,
                                              );
                                            }
                                            return FlLine(
                                                color: Colors.transparent);
                                          },
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barGroups: [
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY: receita,
                                                color: Colors.green,
                                                width: 40,
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 1,
                                            barRods: [
                                              BarChartRodData(
                                                toY: despesa,
                                                color: Colors.red,
                                                width: 40,
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      formatarMesAno(datas[currentIndex]),
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                formatarParaReal(receita),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "Receitas",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                formatarParaReal(despesa),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "Despesas",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
    );
  }

  Widget modalCategorias() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black,
          ),
          height: 3,
          width: 130,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          child: Text(
            'Selecionar conta',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              filtroConta = "todas";
            });
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.azulPrimario,
                    child: Icon(
                      Icons.format_list_bulleted_sharp,
                      color: Colors.white,
                    ))),
            title: Text(
              "Todas as contas",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),
        for (var i = 0; i < listaContasAtuais.length; i++) iconesContas(i),
      ],
    );
  }

  Widget iconesContas(int i) {
    bool temImg() {
      if (listaContasAtuais[i].banco.img == "Cofrinho" ||
          listaContasAtuais[i].banco.img == "Carteira" ||
          listaContasAtuais[i].banco.img == "Banco") {
        return false;
      }
      return true;
    }

    AssetImage? imgConta() {
      if (listaContasAtuais[i].banco.img == "Cofrinho" ||
          listaContasAtuais[i].banco.img == "Carteira" ||
          listaContasAtuais[i].banco.img == "Banco") {
        return null;
      }
      return AssetImage(listaContasAtuais[i].banco.img);
    }

    Icon? iconConta() {
      if (listaContasAtuais[i].banco.img == "Cofrinho" ||
          listaContasAtuais[i].banco.img == "Carteira" ||
          listaContasAtuais[i].banco.img == "Banco") {
        if (listaContasAtuais[i].banco.img == "Cofrinho") {
          return Icon(
            Icons.savings,
            color: Colors.white,
          );
        }
        if (listaContasAtuais[i].banco.img == "Carteira") {
          return Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
          );
        }
        return Icon(
          Icons.account_balance_rounded,
          color: Colors.white,
        );
      }
      return null;
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              filtroConta = listaContasAtuais[i].nome;
            });
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                    radius: 15,
                    backgroundColor: temImg() ? null : AppColors.azulPrimario,
                    backgroundImage: imgConta(),
                    child: iconConta())),
            title: Text(
              listaContasAtuais[i].nome,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        )
      ],
    );
  }
}
