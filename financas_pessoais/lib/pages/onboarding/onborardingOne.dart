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
      backgroundColor: AppColors.azulPrimario,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Lottie.asset("assets/animacoes/onboardingOne.json"),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500), // estilo base
                          children: [
                            const TextSpan(
                              text: 'Gerencie suas finanças com o ',
                              style: TextStyle(color: Colors.white),
                            ),
                            const TextSpan(
                              text: 'Walletfy',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          child: Text(
                            "Uma maneira conveniente de gerenciar seu dinheiro com segurança pelo celular.",
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                    height: 6,
                                    width: 65,
                                  ), 
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white38,
                                      ),
                                      height: 6,
                                      width: 35,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  print("Próxima onboarding");
                                  Navigator.pushNamed(context, '/onboardingTwo');
                                },
                                child: Text("Skip")
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}