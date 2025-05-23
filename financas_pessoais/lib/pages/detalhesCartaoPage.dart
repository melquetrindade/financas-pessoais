import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:flutter/material.dart';

class DetalhesCartaoPage extends StatefulWidget {
  final Cartao cartao;
  const DetalhesCartaoPage({super.key, required this.cartao});

  @override
  State<DetalhesCartaoPage> createState() => _DetalhesCartaoPageState();
}

class _DetalhesCartaoPageState extends State<DetalhesCartaoPage> {
  @override
  Widget build(BuildContext context) {
    print("Detalhes do Cartão: \t\n ${widget.cartao.nome}");

    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      appBar: AppBar(
        backgroundColor: AppColors.azulPrimario,
        centerTitle: true,
        title: Text(
          "Detalhes da fatura",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homeController');
          },
        ),
      ),
      body: Center(
        child: Text("Tela de detalhes do cartão"),
      ),
    );
  }
}

/*
Cartao(
        nome: "Next",
        icone: Banco(nome: "Cartão", img: "Cartão"),
        limite: "500,00",
        diaFechamento: "08",
        diaVencimento: "15",
        fatura: "0,00",
        conta:
          Conta(
            nome: "Next",
            saldo: "2.003,90",
            banco: Banco(img: "assets/next.jpg", nome: "Next")
          )),
 */