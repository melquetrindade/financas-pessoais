import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/widgets/home/appBar.dart';
import 'package:financas_pessoais/widgets/home/cardCartoes.dart';
import 'package:financas_pessoais/widgets/home/cardContas.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RepositoryContas repositoryContas = RepositoryContas();
  final RepositoryCartao repositoryCartao = RepositoryCartao();

  void mostarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ocupar a altura total
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Bordas arredondadas no topo
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 50,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bottom Sheet Tela Cheia",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Fechar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulPrimario,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: MyAppBar()
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              Cardcontas(listContas: RepositoryContas().contas),
              SizedBox(
                height: 20,
              ),
              Cardcartoes(listCartao: repositoryCartao.cartoes),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
