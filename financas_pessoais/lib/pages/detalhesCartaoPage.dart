import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:flutter/material.dart';

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

  List<Fatura> filtrarFaturasPorCartao(Cartao cartao) {
    print("entrou no filtrar");
    List<Fatura> faturasFiltradas = [];
    //List<Fatura> faturasOrdenadas = [];

    for (var fatura in repositoryFatura.faturas) {
      if (fatura.cartao.nome == widget.cartao.nome) {
        faturasFiltradas.add(fatura);
      }
    }
    ordenarPorDataDecrescente(faturasFiltradas, (f) => f.data);

    faturasFiltradas.forEach((f) => print(f.data));
    /*
    for (int y = 0; y < faturasFiltradas.length; y++) {
      print("${faturasFiltradas[y].data}");
    }*/
    return faturasFiltradas;
  }

  void ordenarPorDataDecrescente(List<dynamic> lista, String Function(dynamic) getData) {
    lista.sort((a, b) {
      DateTime dataA = _converterParaDateTime(getData(a));
      DateTime dataB = _converterParaDateTime(getData(b));
      return dataB.compareTo(dataA); // Mais recente primeiro
    });
  }

  DateTime _converterParaDateTime(String data) {
    return DateTime.parse(
      "${data.substring(6, 10)}-${data.substring(3, 5)}-${data.substring(0, 2)}"
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Detalhes do Cartão: \t\n ${widget.cartao.nome}");
    repositoryFatura = RepositoryFatura();
    listaFaturas = filtrarFaturasPorCartao(widget.cartao);

    if (!listaFaturas.isEmpty) {
      print("${listaFaturas[currentIndex].cartao.nome}");
    }

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
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.yellow.shade200,
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
                        Icons.arrow_back,
                        color: listaFaturas.length > (currentIndex + 1)
                            ? Colors.black
                            : Colors.grey,
                      )),
                  Container(
                    color: Colors.blue.shade200,
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
                              child: Text("${listaFaturas[index].data}"));
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
                        Icons.arrow_forward,
                        color: currentIndex > 0 ? Colors.black : Colors.grey,
                      )),
                ],
              ),
            )
          ],
        ));
  }
}

/*
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Image.network(
                                  banners[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );*/

/*
Cartao(
        nome: "Next",
        icone: Banco(nome: "Cartão", img: "Cartão"),
        limite: "500,00",
        diaFechamento: "08",
        diaVencimento: "15",
        fatura: "0,00",
        conta:
          Conta(
            nome: "Next",
            saldo: "2.003,90",
            banco: Banco(img: "assets/next.jpg", nome: "Next")
          )),
 */