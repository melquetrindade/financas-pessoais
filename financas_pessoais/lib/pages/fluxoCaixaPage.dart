import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FluxoCaixaPage extends StatefulWidget {
  const FluxoCaixaPage({super.key});

  @override
  State<FluxoCaixaPage> createState() => _FluxoCaixaPageState();
}

class _FluxoCaixaPageState extends State<FluxoCaixaPage> {
  late RepositoryLancamentos repositoryLancamentos;
  late List<Lancamentos> listaLancamentos;
  late List<String> datas;
  PageController pageController = PageController();
  int currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    repositoryLancamentos = RepositoryLancamentos();
    listaLancamentos = repositoryLancamentos.lancamentos;
    datas = ordenarMesAno(listaLancamentos);

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Fluxo de caixa",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
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
                                border:
                                    Border.all(color: AppColors.azulPrimario),
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
                    cardLancamento()
                  ],
                ),
              ),
            ))
          ],
        ));
  }

  Widget cardLancamento() {
    List<Lancamentos> lancamentos = listaLancamentos;
    List<Lancamentos> lancamentosAux = [];

    List<Lancamentos> filtrarLancamentosPorMesAno() {
      // Extrai mês e ano da data base
      final partesBase = datas[currentIndex].split('/');
      final int mesBase = int.parse(partesBase[0]);
      final int anoBase = int.parse(partesBase[1]);

      // Filtra os lançamentos
      return lancamentos.where((lanc) {
        final partesData = lanc.data.split('/');
        final int mes = int.parse(partesData[1]);
        final int ano = int.parse(partesData[2]);
        return mes == mesBase && ano == anoBase;
      }).toList();
    }

    Color corPagamento(double valor) {
      return valor >= 0 ? AppColors.azulPrimario : Colors.red;
    }

    String formatarParaReal(double valor) {
      final formatter = NumberFormat.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

      return formatter.format(valor);
    }

    double converterValor(String valorStr, bool negativo) {
      String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
      double valor = double.parse(valorLimpo);
      return negativo ? -valor : valor;
    }

    lancamentosAux = filtrarLancamentosPorMesAno();

    return Column(
      children: [
        for(var lancamento in lancamentosAux) ListTile(
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
      ],
    );
  }
}
