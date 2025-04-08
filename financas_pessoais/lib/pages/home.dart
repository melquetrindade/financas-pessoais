import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/categorias.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RepositoryCategorias repositoryCategorias = RepositoryCategorias();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulPrimario,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
            ],
          ),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  constraints: BoxConstraints(
                    minHeight: 200,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saldo geral",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "R\$ 1.000,00",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Icon(Icons.visibility_off_outlined)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                            color: AppColors.azulPrimario,
                            thickness: 1,
                            height: 20,
                          ),
                        ),
                        Text(
                          "Minhas contas",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("assets/bb.png"))),
                          title: Text("Nubank"),
                          trailing: Text(
                            "R\$ 1.000,00",
                            style: TextStyle(
                                fontSize: 15, color: AppColors.azulPrimario),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("assets/nubank.png"))),
                          title: Text("Nubank"),
                          trailing: Text(
                            "R\$ 1.000,00",
                            style: TextStyle(
                                fontSize: 15, color: AppColors.azulPrimario),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("assets/itau.jpg"))),
                          title: Text("Nubank"),
                          trailing: Text(
                            "R\$ 1.000,00",
                            style: TextStyle(
                                fontSize: 15, color: AppColors.azulPrimario),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircleAvatar(
                                radius: 15, 
                                backgroundColor: repositoryCategorias.categorias[0].cor,
                                child: Icon(repositoryCategorias.categorias[0].icon, color: Colors.white,),
                            )
                          ),
                          title: Text(repositoryCategorias.categorias[0].nome),
                          trailing: Text(
                            "R\$ 1.000,00",
                            style: TextStyle(
                                fontSize: 15, color: AppColors.azulPrimario),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: BorderSide(
                                    color: AppColors.azulPrimario,
                                    width: 1,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Gerenciar contas',
                                style: TextStyle(
                                    color: AppColors.azulPrimario,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  constraints: BoxConstraints(
                    minHeight: 200,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Todas as faturas"),
                                Text("R\$ 1.000,00"),
                              ],
                            ),
                            Icon(Icons.visibility_off_outlined)
                          ],
                        ),
                        Divider(
                          color: AppColors.azulPrimario,
                          thickness: 1,
                          height: 20,
                        ),
                        Text("Minhas cartões"),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
