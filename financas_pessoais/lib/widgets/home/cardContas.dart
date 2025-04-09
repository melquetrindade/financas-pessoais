import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:flutter/material.dart';

class Cardcontas extends StatefulWidget {
  final List<Conta> listContas;
  const Cardcontas({super.key, required this.listContas});

  @override
  State<Cardcontas> createState() => _CardcontasState();
}

class _CardcontasState extends State<Cardcontas> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                            fontWeight: FontWeight.w600, fontSize: 18),
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              for (var i = 0; i < widget.listContas.length; i++) cardConta(i),
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
                    onPressed: () {
                      //mostarModal(context);
                      Navigator.pushNamed(context, '/gerenciaConta');
                    },
                    child: Text(
                      'Gerenciar contas',
                      style: TextStyle(
                          color: AppColors.azulPrimario, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget cardConta(int i) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
          width: 40,
          height: 40,
          child: CircleAvatar(
              radius: 15, backgroundImage: AssetImage(widget.listContas[i].icone))),
      title: Text(widget.listContas[i].nome),
      trailing: Text(
        "R\$ ${widget.listContas[i].saldo}",
        style: TextStyle(fontSize: 15, color: AppColors.azulPrimario),
      ),
    );
  }
}


/* 
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
              title: Text("Itaú"),
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
                    backgroundColor:
                        repositoryCategorias.categorias[0].cor,
                    child: Icon(
                      repositoryCategorias.categorias[0].icon,
                      color: Colors.white,
                    ),
                  )),
              title: Text(repositoryCategorias.categorias[0].nome),
              trailing: Text(
                "R\$ 1.000,00",
                style: TextStyle(
                    fontSize: 15, color: AppColors.azulPrimario),
              ),
            ),
*/