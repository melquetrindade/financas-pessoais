import 'package:financas_pessoais/pages/onboarding/onboardingTwo.dart';
import 'package:financas_pessoais/pages/onboarding/onborardingOne.dart';
import 'package:flutter/material.dart';

class OnboardingcontrollerPage extends StatefulWidget {
  const OnboardingcontrollerPage({super.key});

  @override
  State<OnboardingcontrollerPage> createState() => _OnboardingcontrollerPageState();
}

class _OnboardingcontrollerPageState extends State<OnboardingcontrollerPage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          OnborardingOnePage(),
          OnborardingTwoPage()
        ],
        onPageChanged: setPaginaAtual,
      ),
    );
  }
}