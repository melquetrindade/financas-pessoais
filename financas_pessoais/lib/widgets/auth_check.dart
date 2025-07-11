import 'package:financas_pessoais/pages/autenticacao/loginPage.dart';
import 'package:financas_pessoais/pages/autenticacao/signupPage.dart';
import 'package:financas_pessoais/pages/homeControllerPage.dart';
import 'package:financas_pessoais/pages/onboarding/onboardingTwo.dart';
import 'package:financas_pessoais/pages/onboarding/onborardingOne.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:financas_pessoais/repository/perfil.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late AuthService auth;
  bool teste = true;
  @override
  Widget build(BuildContext context) {
    auth = context.watch<AuthService>();
    reload();

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null &&
        auth.onboardingOneView == false &&
        auth.onboardingTwoView == false) {
      return OnborardingOnePage();
    } else if (auth.usuario == null &&
        auth.onboardingOneView == true &&
        auth.onboardingTwoView == false) {
      return OnborardingTwoPage();
    } else if (auth.usuario == null &&
        auth.onboardingOneView == true &&
        auth.onboardingTwoView == true &&
        auth.loginOrSigin == true) {
      return LoginPage();
    } else if (auth.usuario == null &&
        auth.onboardingOneView == true &&
        auth.onboardingTwoView == true &&
        auth.loginOrSigin == false) {
      return SignUpPage();
    } else {
      print('Nome do usuário: ${auth.usuario!.displayName}');
      return HomeControllerPage();
    }
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  reload() {
    if (auth.usuario != null &&
        context.read<RepositoryContas>().jaCarregou) {
      print('entrou no if do auth de contas');
      context.read<RepositoryContas>().resetLista();
    }
    if (auth.usuario != null && context.read<RepositoryCartao>().jaCarregou) {
      print('entrou no if do auth de cartão');
      context.read<RepositoryCartao>().resetLista();
    }
    if (auth.usuario != null && context.read<RepositoryFatura>().jaCarregou) {
      print('entrou no if do auth de faturas');
      context.read<RepositoryFatura>().resetLista();
    }
    if (auth.usuario != null && context.read<RepositoryLancamentos>().jaCarregou) {
      print('entrou no if do auth de lançamentos');
      context.read<RepositoryLancamentos>().resetLista();
    }
    if (auth.usuario != null && context.read<RepositoryGastos>().jaCarregou) {
      print('entrou no if do auth de gastos');
      context.read<RepositoryGastos>().resetLista();
    }
    if (auth.usuario != null && context.read<RepositoryPerfil>().jaCarregou) {
      print('entrou no if do auth de perfil');
      context.read<RepositoryPerfil>().resetNome();
    }
  }
}
