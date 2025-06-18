import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:financas_pessoais/pages/criarLimiteGastos.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  late RepositoryGastos repositoryGastos;
  late List<Gastos> listaGastos;
  PageController pageController = PageController();
  int currentIndex = 0;
  late List<String> datas;
  late List<Gastos> gastosAtuais;

  List<String> ordenarMesAno(List<Gastos> gastos) {
    List<String> datas = [];

    if (gastos.isNotEmpty) {
      for (var gasto in gastos) {
        datas.add(gasto.data);
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
    return datas;
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

  List<Gastos> filtrarGastosPorMesAno(
      List<Gastos> listaGastos) {
    // Extrai mês e ano da data base
    if (listaGastos.isNotEmpty) {
      final partesBase = datas[currentIndex].split('/');
      final int mesBase = int.parse(partesBase[0]);
      final int anoBase = int.parse(partesBase[1]);

      // Filtra os gastos pela correspondência de mês/ano
      return listaGastos.where((gasto) {
        final partesData = gasto.data.split('/');
        final int mesGasto = int.parse(partesData[1]); // mês está na posição 1
        final int anoGasto = int.parse(partesData[2]); // ano está na posição 2

        return mesGasto == mesBase && anoGasto == anoBase;
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    repositoryGastos = RepositoryGastos();
    listaGastos = repositoryGastos.gastos;
    datas = ordenarMesAno(listaGastos);
    gastosAtuais = filtrarGastosPorMesAno(listaGastos);

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
            backgroundColor: AppColors.azulPrimario,
            centerTitle: true,
            title: Text(
              "Limites de gastos",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CriarLimiteGastosPage()),
                    );
                  },
                  icon: Icon(Icons.add))
            ]),
        body: listaGastos.isEmpty
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
                      "Você ainda não definiu limites de gastos!",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : Container(
                color: AppColors.backgroundClaro,
                child: Column(
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
                            for (int i = 0; i < gastosAtuais.length; i++)
                              cardGasto(i)
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ));
  }

  String formatarParaReal(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return formatter.format(valor);
  }

  double converterValor(String valorStr) {
    String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
    double valor = double.parse(valorLimpo);
    return valor;
  }
  /*
  double converterLimite(String valorStr) {
    String valorLimpo = valorStr.replaceAll('.', '').replaceAll(',', '.');
    double valor = double.parse(valorLimpo);
    return valor;
  }*/

  Widget cardGasto(int i) {
    double diferenca = converterValor(gastosAtuais[i].limite) -
        converterValor(gastosAtuais[i].valor);
    double barra = 0;

    double calcularPorcentagem(double numero, double total) {
      if (total != 0) {
        double porcentagem = (numero / total) * 100;
        return porcentagem;
      } else {
        return 0;
      }
    }

    double setBarra() {
      if (diferenca < 0) {
        return 0;
      }
      return calcularPorcentagem(converterValor(gastosAtuais[i].valor),
          converterValor(gastosAtuais[i].limite));
    }

    barra = setBarra();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 35,
                            height: 35,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor: gastosAtuais[i].categoria.cor,
                                child: Icon(
                                  gastosAtuais[i].categoria.icon,
                                  color: Colors.white,
                                ))),
                        SizedBox(width: 8),
                        Text(
                          gastosAtuais[i].categoria.nome,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Divider(),
                    ),
                    Text(
                      "Limite de gasto excedido",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${formatarParaReal(diferenca)}",
                              style: TextStyle(
                                color:
                                    diferenca < 0 ? Colors.red : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " / ${formatarParaReal(converterValor(gastosAtuais[i].limite))}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: barra),
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Container(
                      color: diferenca < 0 ? Colors.red : Colors.green,
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
