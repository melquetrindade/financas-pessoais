import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnborardingOnePage extends StatefulWidget {
  const OnborardingOnePage({super.key});

  @override
  State<OnborardingOnePage> createState() => _OnborardingOnePageState();
}

class _OnborardingOnePageState extends State<OnborardingOnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.azulPrimario,
        child: Column(
          children: [
            Container(
              child: Lottie.network("https://lottie.host/ab413e64-e9c2-4637-b0f0-663541dcb137/WRvkySGpPj.json")
            ),
            Container(
              child: Column(
                children: [
                  Text("Gerencie suas"),
                  Text("finanças com o"),
                  Text("Walletfy"),
                ],
              ),
            ),
            Container(
              child: Text("Uma maneira conveniente de gerenciar seu dinheiro com segurança pelo celular."),
            )
          ],
        ),
      ),
    );
  }
}

//https://lottie.host/9bf012a8-c912-4c60-a3a5-b15faa07e0c3/7xK8AIzC9C.json