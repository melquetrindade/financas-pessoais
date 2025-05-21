import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawser extends StatefulWidget {
  const MyHeaderDrawser({super.key});

  @override
  State<MyHeaderDrawser> createState() => _MyHeaderDrawserState();
}

class _MyHeaderDrawserState extends State<MyHeaderDrawser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.azulPrimario,
          width: double.infinity,
          height: 190,
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/melque.png"),
                )
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'Melque Rodrigues',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print("abrir pag de editar perfil");
                  Navigator.pushNamed(context, "/onboardingTwo");
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Icon(
                        Icons.person_outline_outlined,
                        size: 23,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Perfil',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  //authService.logout();
                  print("Fazer logout");
                  Navigator.pushNamed(context, "/onboardingOne");
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Icon(
                        Icons.logout,
                        size: 23,
                        color: AppColors.azulPrimario,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Sair',
                            style: TextStyle(
                                color: AppColors.azulPrimario,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
