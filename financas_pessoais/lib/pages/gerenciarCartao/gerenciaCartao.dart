import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/pages/gerenciarCartao/criarCartao.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:financas_pessoais/widgets/gerenciarCartao/cardCartao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GerenciarCartaoPage extends StatefulWidget {
  const GerenciarCartaoPage({super.key});

  @override
  State<GerenciarCartaoPage> createState() => _GerenciarCartaoPageState();
}

class _GerenciarCartaoPageState extends State<GerenciarCartaoPage> {
  late RepositoryCartao repositoryCartao;
  late RepositoryFatura repositoryFatura;

  @override
  Widget build(BuildContext context) {
    print('Atualiza o gerencia cartão');
    repositoryFatura = RepositoryFatura();
    repositoryCartao = context.watch<RepositoryCartao>();

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Cartões',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CriarCartaoPage()));
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 37,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "Aqui estão todos os seus cartões. Você pode editá-los caso haja necessidade.",
                            softWrap: true,
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    repositoryCartao.cartoes.length != 0
                        ? CardGerenciaCartao(
                            listCartao: repositoryCartao.cartoes,
                            listaFatura: repositoryFatura.faturas,
                          )
                        : Padding(
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
                                      "Clique no ícone de mais para criar um novo cartão",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
