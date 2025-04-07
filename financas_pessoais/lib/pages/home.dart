import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                        border:
                            Border.all(color: Colors.white, width: 2),
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
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                constraints: BoxConstraints(
                  minHeight: 300, // Define uma altura mínima
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
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Saldo geral"),
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
                      Text("Minhas contas"),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.credit_card),
                        title: Text("Nubank"),
                        trailing: Text("R\$ 1.000,00"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.credit_card),
                        title: Text("Nubank"),
                        trailing: Text("R\$ 1.000,00"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.credit_card),
                        title: Text("Nubank"),
                        trailing: Text("R\$ 1.000,00"),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'HOME',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 177, 136, 136), fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
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
