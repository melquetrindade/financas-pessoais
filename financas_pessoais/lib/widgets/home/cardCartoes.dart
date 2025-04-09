import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:flutter/material.dart';

class Cardcartoes extends StatefulWidget {
  final List<Cartao> listCartao;
  const Cardcartoes({super.key, required this.listCartao});

  @override
  State<Cardcartoes> createState() => _CardcartoesState();
}

class _CardcartoesState extends State<Cardcartoes> {
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
                        "Todas as faturas",
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
                "Meus cartões",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              for (var i = 0; i < widget.listCartao.length; i++) cardCartao(i),
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
                      print("Vai para tela de gerenciar cartões");
                    },
                    child: Text(
                      'Gerenciar cartões',
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

  Widget cardCartao(int i) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(widget.listCartao[i].icone))),
          title: Text(widget.listCartao[i].nome),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Disponível",style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800
                      ),),
                      Text("R\$ ${widget.listCartao[i].limite}", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Fatura Atual", style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800
                      ),),
                      Text("R\$ ${widget.listCartao[i].limite}", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: i == 1 ? Colors.red : i == 0 ? Colors.blue.shade600 : Colors.black
                      ),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.azulPrimario,
          thickness: 1,
        )
      ],
    );
  }
}
