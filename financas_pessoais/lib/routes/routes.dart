import 'package:financas_pessoais/pages/autenticacao/loginPage.dart';
import 'package:financas_pessoais/pages/autenticacao/signupPage.dart';
import 'package:financas_pessoais/pages/gerenciarCartao/gerenciaCartao.dart';
import 'package:financas_pessoais/pages/gerenciarConta/gerenciarConta.dart';
import 'package:financas_pessoais/pages/home.dart';
import 'package:financas_pessoais/pages/homeControllerPage.dart';
import 'package:financas_pessoais/pages/notificacaoPage.dart';
import 'package:financas_pessoais/pages/onboarding/onboardingTwo.dart';
import 'package:financas_pessoais/pages/onboarding/onborardingOne.dart';
import 'package:financas_pessoais/pages/splash/splashPage.dart';
import 'package:financas_pessoais/widgets/auth_check.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/authCheck': (_) => const AuthCheck(),
    '/home': (_) => const Home(),
    '/homeController': (_) => const HomeControllerPage(),
    '/gerenciaConta': (_) => const GerenciarContaPage(),
    '/gerenciaCartao': (_) => const GerenciarCartaoPage(),
    '/splash': (_) => const SplashPage(),
    '/onboardingOne': (_) => const OnborardingOnePage(),
    '/onboardingTwo': (_) => const OnborardingTwoPage(),
    '/login': (_) => const LoginPage(),
    '/signUp': (_) => const SignUpPage(),
    '/notificacaoPage': (_) => const NotificacaoPage(),
  };
  static String initial = '/authCheck';
  
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}