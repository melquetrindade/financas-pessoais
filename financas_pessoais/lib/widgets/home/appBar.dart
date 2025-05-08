import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/pages/criarConta.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.azulPrimario,
      floating: true,
      snap: true,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                    onTap: () {
                      print("Tocou no perfil");
                    },
                  ),
                  const SizedBox(width: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Boa tarde,",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          "Melque",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue.shade300,
                    child: Icon(
                      Icons.notifications_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  print("Mostar tela de notificações");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CriarContaPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
