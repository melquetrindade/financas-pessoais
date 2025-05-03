import 'package:financas_pessoais/pages/gerenciaCartao.dart';
import 'package:financas_pessoais/pages/gerenciarConta.dart';
import 'package:financas_pessoais/pages/home.dart';
import 'package:financas_pessoais/pages/onboarding/onboardingController.dart';
import 'package:financas_pessoais/pages/onboarding/onboardingTwo.dart';
import 'package:financas_pessoais/pages/onboarding/onborardingOne.dart';
import 'package:financas_pessoais/pages/splash/splashPage.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/onboarding': (_) => const OnboardingcontrollerPage(),
    '/home': (_) => const Home(),
    '/gerenciaConta': (_) => const GerenciarContaPage(),
    '/gerenciaCartao': (_) => const GerenciarCartaoPage(),
    '/splash': (_) => const SplashPage(),
    '/onboardingOne': (_) => const OnborardingOnePage(),
    '/onboardingTwo': (_) => const OnborardingTwoPage(),
  };
  static String initial = '/home';
  
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}