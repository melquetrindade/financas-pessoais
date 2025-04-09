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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Contas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                )),
          )
        ],
      ),
      body: Center(
        child: Text("Tela de gerenciar conta"),
      ),
    );
  }
}
