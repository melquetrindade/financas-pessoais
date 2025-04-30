import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:flutter/material.dart';

class CardGerenciaConta extends StatefulWidget {
  final List<Conta> listContas;
  const CardGerenciaConta({super.key, required this.listContas});

  @override
  State<CardGerenciaConta> createState() => _CardGerenciaContaState();
}

class _CardGerenciaContaState extends State<CardGerenciaConta> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widget.listContas.length; i++) cardConta(i),
      ],
    );
  }

  Widget cardConta(int i) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
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
                              AssetImage(widget.listContas[i].icone))),
                  title: Text(widget.listContas[i].nome),
                  trailing: IconButton(
                      onPressed: () {
                        print("Ir para a página de edição da ${widget.listContas[i].nome}");
                      },
                      icon: Icon(Icons.edit))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  color: AppColors.azulPrimario,
                  thickness: 1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "Saldo Atual",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      "R\$ ${widget.listContas[i].saldo}",
                      style: TextStyle(
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
    );
  }
}

/* 
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

*/