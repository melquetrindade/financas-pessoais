import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/widgets/home/appBar.dart';
import 'package:financas_pessoais/widgets/home/cardCartoes.dart';
import 'package:financas_pessoais/widgets/home/cardContas.dart';
import 'package:financas_pessoais/widgets/home/myHeaderDrawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RepositoryContas repositoryContas = RepositoryContas();
  final RepositoryCartao repositoryCartao = RepositoryCartao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      body: CustomScrollView(
        slivers: [
          MyAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Column(
                children: [
                  Cardcontas(listContas: repositoryContas.contas),
                  const SizedBox(height: 20),
                  Cardcartoes(listCartao: repositoryCartao.cartoes),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawser(),
                  
                ],
              ),
            ),
          ),
        ),
    );
  }
}