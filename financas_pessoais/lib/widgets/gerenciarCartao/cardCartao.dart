import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/pages/gerenciarCartao/editarCartao.dart';
import 'package:flutter/material.dart';

class CardGerenciaCartao extends StatefulWidget {
  final List<Cartao> listCartao;
  const CardGerenciaCartao({super.key, required this.listCartao});

  @override
  State<CardGerenciaCartao> createState() => _CardGerenciaCartaoState();
}

class _CardGerenciaCartaoState extends State<CardGerenciaCartao> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widget.listCartao.length; i++) cardCartao(i),
      ],
    );
  }

  Widget cardCartao(int i) {
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
                          backgroundImage: AssetImage(widget.listCartao[i].icone.img),
                          backgroundColor: widget.listCartao[i].icone.img == "Cartão" ? AppColors.azulPrimario : null,
                          child: widget.listCartao[i].icone.img == "Cartão" ? Icon(Icons.credit_card, color: Colors.white,) : null,
                      )),
                  title: Text(widget.listCartao[i].nome),
                  subtitle: Text("Fecha dia: ${widget.listCartao[i].diaFechamento} - Vence dia: ${widget.listCartao[i].diaVencimento}", style: TextStyle(
                    fontSize: 13,
                  ),),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarCartaoPage(
                                  banco: widget.listCartao[i].icone,
                                  conta: widget.listCartao[i].conta,
                                  diaFecha: widget.listCartao[i].diaFechamento,
                                  diaVencimento: widget.listCartao[i].diaVencimento,
                                  limite: widget.listCartao[i].limite,
                                  nomeCartao: widget.listCartao[i].nome,
                                ))
                        );
                      },
                      icon: Icon(Icons.edit)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    color: AppColors.azulPrimario,
                    height: 0.3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
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
              ],
            ),
          ),
        ),
    );
  }
}
