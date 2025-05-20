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
  bool showSaldo = true;

  @override
  Widget build(BuildContext context) {
    print("rendenziou o card conta00");
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
                        showSaldo ? "R\$ 1.000,00" : "R\$ ---",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, 
                            fontSize: 18,
                            color: showSaldo ? Colors.black : Colors.black54
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSaldo = !showSaldo;
                      });
                    },
                    icon: Icon(showSaldo ? Icons.visibility_off_outlined : Icons.visibility),
                  )
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
    String imgIcone = widget.listContas[i].banco.img;

    Widget? iconeConta() {
      return imgIcone == ""
          ? Icon(
              Icons.add,
              color: Colors.white,
            )
          : imgIcone == "Carteira"
              ? Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                )
              : imgIcone == "Banco"
                  ? Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                    )
                  : imgIcone == "Cofrinho"
                      ? Icon(
                          Icons.savings,
                          color: Colors.white,
                        )
                      : null;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
          width: 40,
          height: 40,
          child: CircleAvatar(
            radius: 15,
            backgroundImage: widget.listContas[i].banco.img == "Carteira" ||
                    widget.listContas[i].banco.img == "Banco" ||
                    widget.listContas[i].banco.img == "Cofrinho"
                ? null
                : AssetImage(widget.listContas[i].banco.img),
            backgroundColor: widget.listContas[i].banco.img == "Carteira" ||
                    widget.listContas[i].banco.img == "Banco" ||
                    widget.listContas[i].banco.img == "Cofrinho"
                ? AppColors.azulPrimario
                : null,
            child: iconeConta(),
          )),
      title: Text(widget.listContas[i].nome),
      trailing: Text(
        showSaldo ? "R\$ ${widget.listContas[i].saldo}" : "R\$ ---",
        style: TextStyle(
          fontSize: 15, 
          color: showSaldo ? AppColors.azulPrimario : Colors.black54
        ),
      ),
    );
  }
}
