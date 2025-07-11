import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  final String nomeUser;
  const MyAppBar({super.key, required this.nomeUser});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String saudacaoComBaseNaHora() {
    final agora = DateTime.now();
    final hora = agora.hour;

    if (hora >= 5 && hora < 12) {
      return "Bom dia,";
    } else if (hora >= 12 && hora < 18) {
      return "Boa tarde,";
    } else {
      return "Boa noite,";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.azulPrimario,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
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
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              AssetImage("assets/bancos/perfil.jpg"),
                        )),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  const SizedBox(width: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          saudacaoComBaseNaHora(),
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          widget.nomeUser,
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
                  Navigator.pushNamed(context, '/notificacaoPage');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
