import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/pages/gerenciarConta/criarConta.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/widgets/gerenciarConta/cardContas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GerenciarContaPage extends StatefulWidget {
  const GerenciarContaPage({super.key});

  @override
  State<GerenciarContaPage> createState() => _GerenciarContaPageState();
}

class _GerenciarContaPageState extends State<GerenciarContaPage> {
  late RepositoryContas repositoryContas;
  late List<Conta> listaContas = [];

  @override
  Widget build(BuildContext context) {
    repositoryContas = context.watch<RepositoryContas>();
    listaContas = repositoryContas.contas;

    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Contas',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    print("add nova conta");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CriarContaPage()),
                    );
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
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "Aqui estão todas as suas contas. Você pode editá-las e ajustar o saldo de cada conta caso haja necessidade.",
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
                    listaContas.length != 0
                        ? CardGerenciaConta(listContas: listaContas)
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
                                      "Clique no ícone de mais para criar uma nova conta",
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
