import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/pages/detalhesCartaoPage.dart';
import 'package:flutter/material.dart';

class Cardcartoes extends StatefulWidget {
  final List<Cartao> listCartao;
  final List<Fatura> listaFatura;
  const Cardcartoes(
      {super.key, required this.listCartao, required this.listaFatura});

  @override
  State<Cardcartoes> createState() => _CardcartoesState();
}

class _CardcartoesState extends State<Cardcartoes> {
  bool showSaldo = true;

  DateTime _converterStringParaDateTime(String data) {
    List<String> partes = data.split('/');
    int dia = int.parse(partes[0]);
    int mes = int.parse(partes[1]);
    int ano = int.parse(partes[2]);

    return DateTime(ano, mes, dia);
  }

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
                        showSaldo ? "R\$ 1.000,00" : "R\$ ---",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: showSaldo ? Colors.black : Colors.black54),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSaldo = !showSaldo;
                      });
                    },
                    icon: Icon(showSaldo
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
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
                      Navigator.pushNamed(context, '/gerenciaCartao');
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
    List<Fatura> faturasFiltradas = [];
    double faturaTotal = 0;

    DateTime hoje = DateTime.now();

    for (var fatura in widget.listaFatura) {
      if (fatura.cartao.nome == widget.listCartao[i].nome) {
        DateTime dataFatura = _converterStringParaDateTime(fatura.data);

        if (dataFatura.month == hoje.month && dataFatura.year == hoje.year) {
          faturasFiltradas.add(fatura);
        }
      }
    }

    void calcFaturaTotal() {
      for (var lancamento in faturasFiltradas[0].lancamentos) {
        if(lancamento.eDespesa){
          String valorFormatado = lancamento.valor.replaceAll(".", "").replaceAll(",", ".");
          double fatura = double.parse(valorFormatado);
          faturaTotal += fatura*-1;
        } 
      }
    }

    Color corFatura() {
      return faturaTotal >= 0 ? AppColors.azulPrimario : Colors.red;
    }

    if(faturasFiltradas.length != 0){
      calcFaturaTotal();
    }

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: widget.listCartao[i].icone.img == "Cartão"
                    ? AppColors.azulPrimario
                    : null,
                backgroundImage: widget.listCartao[i].icone.img == "Cartão"
                    ? null
                    : AssetImage(widget.listCartao[i].icone.img),
                child: widget.listCartao[i].icone.img == "Cartão"
                    ? Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      )
                    : null,
              )),
          title: Text(widget.listCartao[i].nome),
        ),
        InkWell(
          onTap: () {
            //print("abrir pag de detalhes do cartão: ${widget.listCartao[i].nome}");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => (DetalhesCartaoPage(
                          cartao: widget.listCartao[i],
                        ))));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Disponível",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800),
                        ),
                        Text(
                          showSaldo
                              ? "R\$ ${widget.listCartao[i].limite}"
                              : "R\$ ---",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: showSaldo ? Colors.black : Colors.black54),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Fatura Atual",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800),
                        ),
                        Text(showSaldo ? "R\$ ${faturaTotal}" : "R\$ ---",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    showSaldo ? corFatura() : Colors.black45))
                      ],
                    )
                  ],
                ),
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
