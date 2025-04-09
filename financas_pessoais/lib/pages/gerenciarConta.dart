import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';

class GerenciarContaPage extends StatefulWidget {
  const GerenciarContaPage({super.key});

  @override
  State<GerenciarContaPage> createState() => _GerenciarContaPageState();
}

class _GerenciarContaPageState extends State<GerenciarContaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.azulPrimario,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Contas',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    print("add nova conta");
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 37,),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "Aqui estão todas as suas contas. Você pode editá-las e ajustar o saldo de cada conta caso haja necessidade.",
                            softWrap: true,
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/bb.png"))),
                            title: Text("Banco do Brasil"),
                            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Divider(
                              color: AppColors.azulPrimario,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text("Saldo Atual", style: TextStyle(fontSize: 12),),
                                ),
                                Text("R\$ 250,00", style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500, 
                                  color: AppColors.azulPrimario),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                      child: Column(
                        children: [
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
                            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Divider(
                              color: AppColors.azulPrimario,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text("Saldo Atual", style: TextStyle(fontSize: 12),),
                                ),
                                Text("R\$ 1.500,00", style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500, 
                                  color: AppColors.azulPrimario),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/itau.jpg"))),
                            title: Text("Itaú"),
                            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Divider(
                              color: AppColors.azulPrimario,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text("Saldo Atual", style: TextStyle(fontSize: 12),),
                                ),
                                Text("R\$ 10.460,80", style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500, 
                                  color: AppColors.azulPrimario),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/next.jpg"))),
                            title: Text("Next"),
                            trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit))
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Divider(
                              color: AppColors.azulPrimario,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text("Saldo Atual", style: TextStyle(fontSize: 12),),
                                ),
                                Text("R\$ 3.090,80", style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.w500, 
                                  color: AppColors.azulPrimario),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
