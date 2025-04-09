import 'package:financas_pessoais/pages/gerenciarConta.dart';
import 'package:financas_pessoais/pages/home.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/home': (_) => const Home(),
    '/gerenciaConta': (_) => const GerenciarContaPage(),
  };
  static String initial = '/home';
  
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}