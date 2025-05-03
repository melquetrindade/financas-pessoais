import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnborardingTwoPage extends StatefulWidget {
  const OnborardingTwoPage({super.key});

  @override
  State<OnborardingTwoPage> createState() => _OnborardingTwoPageState();
}

class _OnborardingTwoPageState extends State<OnborardingTwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.azulPrimario,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Lottie.asset("assets/onboardingTwo.json"),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
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
                                text: 'Receba alertas sobre limites de gastos com o ',
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
                              "Mantenha o controle do seu dinheiro com alertas em tempo real sobre seus limites de gastos.",
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
                        Spacer(),
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
                                        color: Colors.white38,
                                      ),
                                      height: 6,
                                      width: 35,
                                    ), 
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        height: 6,
                                        width: 65,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    print("Próxima onboarding");
                                    Navigator.pushReplacementNamed(context, '/home');
                                  },
                                  child: Text("Skip")
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//https://lottie.host/9bf012a8-c912-4c60-a3a5-b15faa07e0c3/7xK8AIzC9C.json
//https://lottie.host/7ecb960b-afd0-4342-8681-6243e3332276/EXOkq18myv.json
//https://lottie.host/ab413e64-e9c2-4637-b0f0-663541dcb137/WRvkySGpPj.json
