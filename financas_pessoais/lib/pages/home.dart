import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:financas_pessoais/repository/perfil.dart';
import 'package:financas_pessoais/widgets/home/appBar.dart';
import 'package:financas_pessoais/widgets/home/cardCartoes.dart';
import 'package:financas_pessoais/widgets/home/cardContas.dart';
import 'package:financas_pessoais/widgets/home/myHeaderDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RepositoryContas repositoryContas;
  late RepositoryCartao repositoryCartao;
  late RepositoryFatura repositoryFatura;
  late RepositoryPerfil repositoryPerfil;

  @override
  Widget build(BuildContext context) {
    repositoryFatura = context.watch<RepositoryFatura>();
    repositoryContas = context.watch<RepositoryContas>();
    repositoryCartao = context.watch<RepositoryCartao>();
    repositoryPerfil = context.watch<RepositoryPerfil>();

    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      body: CustomScrollView(
        slivers: [
          MyAppBar(nomeUser: repositoryPerfil.nome,),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Column(
                children: [
                  Cardcontas(
                    listContas: repositoryContas.contas,
                    isLoading: repositoryContas.isLoading,
                  ),
                  const SizedBox(height: 20),
                  Cardcartoes(
                    listCartao: repositoryCartao.cartoes,
                    listaFatura: repositoryFatura.faturas,
                    isLoading: repositoryCartao.isLoading,
                  ),
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
                MyHeaderDrawser(nomeUser: repositoryPerfil.nome,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
