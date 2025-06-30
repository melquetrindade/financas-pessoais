import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

  /*
  void mostrarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.93,
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
  }*/

  double moduloValor(double valor) {
    return valor < 0 ? -(valor) : valor;
  }

  void setMaximoYX() {
    double receitaAux = 0;
    double despesaAux = 0;

    receitaAux = moduloValor(receita);
    despesaAux = moduloValor(despesa);

    if (receitaAux != 0 && despesaAux != 0) {
      if (receitaAux != despesaAux) {
        if (receitaAux > despesaAux) {
          setState(() {
            double porc = (receitaAux * 10) / 100;
            maxY = porc + receitaAux;
            minY = -(porc + receitaAux);
          });
        } else {
          setState(() {
            double porc = (despesaAux * 10) / 100;
            maxY = porc + despesaAux;
            minY = -(porc + despesaAux);
          });
        }
      } else {
        setState(() {
          double porc = (receitaAux * 10) / 100;
          maxY = porc + receitaAux;
          minY = -(porc + receitaAux);
        });
      }
    }
  }

  List<String> ordenarMesAno(List<Lancamentos> lancamentos) {
    List<String> datas = [];

    for (var lancamento in lancamentos) {
      datas.add(lancamento.data);
    }

    // 1. Converte cada string para DateTime (usando o 1º dia do mês).
    final List<DateTime> convertidas = datas.map((d) {
      final partes = d.split('/'); // [dd, mm, aaaa]
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes); // dia = 1 (default)
    }).toList();

    // 2. Ordena do mais recente (desc) para o mais antigo (asc).
    convertidas.sort((a, b) => b.compareTo(a));

    // 3. Garante unicidade e formata como "mm/aaaa".
    final Set<String> jaAdicionados = {};
    final List<String> resultado = [];

    for (final data in convertidas) {
      final String mesAno =
          '${data.month.toString().padLeft(2, '0')}/${data.year}';
      if (jaAdicionados.add(mesAno)) {
        // só entra se ainda não existir
        resultado.add(mesAno);
      }
    }
    return resultado;
  }

  String formatarMesAno(String mesAno) {
    // Lista com nomes dos meses em português
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

    // Divide a string "mm/aaaa"
    final partes = mesAno.split('/');
    final int mes = int.parse(partes[0]);
    final int ano = int.parse(partes[1]);

    // Verifica o ano atual
    final int anoAtual = DateTime.now().year;

    // Nome do mês correspondente
    final String nomeMes = nomesMeses[mes - 1];

    // Se for o ano atual, retorna só o nome completo
    if (ano == anoAtual) {
      return nomeMes;
    }

    // Caso contrário, retorna abreviado + ano (com ponto)
    final String abreviado = nomeMes.substring(0, 3);
    return '$abreviado.$ano';
  }

  List<Lancamentos> filtrarPorMesAno(
    List<Lancamentos> lancamentos,
    String dataBase,
  ) {
    // --- Extrai mês e ano da dataBase ---
    final partesBase = dataBase.split('/');
    if (partesBase.length != 2) return []; // formato inválido

    final int mesBase = int.tryParse(partesBase[0]) ?? -1;
    final int anoBase = int.tryParse(partesBase[1]) ?? -1;
    if (mesBase < 1 || mesBase > 12 || anoBase < 0) return []; // inválido

    // --- Filtra a lista ---
    return lancamentos.where((l) {
      final partesData = l.data.split('/'); // "dd/mm/aaaa"
      if (partesData.length != 3) return false; // formato errado

      final int mesLanc = int.tryParse(partesData[1]) ?? -1;
      final int anoLanc = int.tryParse(partesData[2]) ?? -1;

      return mesLanc == mesBase && anoLanc == anoBase;
    }).toList();
  }

  double converterValor(String valorStr, bool negativo) {
    String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
    double valor = double.parse(valorLimpo);
    return negativo ? -valor : valor;
  }

  void calcReceitaDespesa() {
    double receitaAux = 0;
    double despesaAux = 0;
    if (lancamentosAtuais.isNotEmpty) {
      for (var lancamento in lancamentosAtuais) {
        double valor = converterValor(lancamento.valor, lancamento.eDespesa);
        if (valor < 0) {
          despesaAux += valor;
        } else {
          receitaAux += valor;
        }
      }

      setState(() {
        receita = receitaAux;
        despesa = despesaAux;
      });
    }
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
    repositoryContas = RepositoryContas();
    listaContas = repositoryContas.contas;
    repositoryLancamentos = RepositoryLancamentos();
    listaLancamentos = repositoryLancamentos.lancamentos;
    datas = ordenarMesAno(listaLancamentos);
    lancamentosAtuais = filtrarPorMesAno(listaLancamentos, datas[currentIndex]);
    listaContasAtuais = filtraContasAtuais();
    calcReceitaDespesa();
    setMaximoYX();
    
    for (var conta in listaContasAtuais) {
      print("conta: ${conta.nome}");
    }

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
      body: Container(
        //width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              //width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (datas.length > (currentIndex + 1)) {
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
                              border: Border.all(color: AppColors.azulPrimario),
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
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                          //mostrarModal(context);
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
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
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
                                          color: Colors
                                              .transparent); // Oculta outras linhas
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
                                //color: Colors.blue,
                                //height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          formatarParaReal(receita),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "Receitas",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "Despesas",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "1.000,00",
                                          style: TextStyle(
                                              color: AppColors.azulPrimario,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Saldo",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  /*
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
        for (var i = 0; i < listaDeCategorias().length; i++)
          iconesCategorias(i, listaDeCategorias()),
      ],
    );
  }*/
}
