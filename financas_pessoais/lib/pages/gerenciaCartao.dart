import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/widgets/gerenciarCartao/cardCartao.dart';
import 'package:flutter/material.dart';

class GerenciarCartaoPage extends StatefulWidget {
  const GerenciarCartaoPage({super.key});

  @override
  State<GerenciarCartaoPage> createState() => _GerenciarCartaoPageState();
}

class _GerenciarCartaoPageState extends State<GerenciarCartaoPage> {
  final RepositoryCartao repositoryCartao = RepositoryCartao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.azulPrimario,
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
                    print("add novo cartão");
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 37,),
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
                    CardGerenciaCartao(listCartao: repositoryCartao.cartoes,)
                  ],
                ),
                
              ],
            ),
          ),
        ));
  }
}