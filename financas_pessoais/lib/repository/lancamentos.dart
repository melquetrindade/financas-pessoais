import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:flutter/material.dart';

import '../model/bancos.dart';

class RepositoryLancamentos {
  final List<Lancamentos> _lancamentos = [
    Lancamentos(
      valor: "200,00", 
      descricao: "Controle do PS4", 
      data: "02/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "85,00",
      descricao: "Fifa 25",
      data: "23/05/2025",
      eDespesa: true,
      categoria: Categorias(
          nome: "Compras ",
          cor: Colors.pink,
          icon: Icons.shopping_bag_outlined),
      conta: null,
      cartao: Cartao(
          nome: "Banco do Brasil",
          icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
          limite: "1.000,00",
          diaFechamento: "01",
          diaVencimento: "30",
          conta: Conta(
              nome: "Banco do Brasil",
              saldo: "1.567,90",
              banco:
                  Banco(img: "assets/bb.png", nome: "Banco do Brasil"))),
    ),
    Lancamentos(
      valor: "150,00", 
      descricao: "Compra do Red Dead", 
      data: "23/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "100,00", 
      descricao: "Compra de Fone", 
      data: "23/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "50,00", 
      descricao: "Janta", 
      data: "10/04/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Bares e restaurantes", cor: Colors.deepPurple.shade800, icon: Icons.wine_bar), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco PAN",
        icone: Banco(nome: "Banco PAN", img: "assets/pan.png"),
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "29",
        conta: Conta(
            nome: "Banco PAN", 
            saldo: "10.000,00",
            banco: Banco(img: "assets/pan.png", nome: "Banco PAN")
        )),
    ),
    Lancamentos(
      valor: "150,00", 
      descricao: "Aposta ganha na betano", 
      data: "30/04/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Investimentos", cor: Colors.tealAccent.shade700, icon: Icons.list_sharp), 
      conta: Conta(nome: "Banco do Brasil", saldo: "1.567,90", banco: Banco(nome: "Banco do Brasil", img: "assets/bb.png")), 
      cartao: null
    ),
    Lancamentos(
      valor: "20,00", 
      descricao: "Transporte", 
      data: "02/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Transporte", cor: Colors.blue.shade300, icon: Icons.bus_alert_sharp), 
      conta: Conta(nome: "Banco PAN", saldo: "10.000,00", banco: Banco(nome: "Banco PAN", img: "assets/pan.png")), 
      cartao: null
    ),
    Lancamentos(
      valor: "500,00", 
      descricao: "Aluguel", 
      data: "02/05/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Outras Receitas", cor: Colors.teal.shade700, icon: Icons.show_chart_sharp), 
      conta: null, 
      cartao: Cartao(
        nome: "Banco do Brasil",
        icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
        limite: "1.000,00",
        diaFechamento: "01",
        diaVencimento: "30",
        conta: Conta(
          nome: "Banco do Brasil",
          saldo: "1.567,90",
          banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil")  
        )),
    ),
    Lancamentos(
      valor: "75,00", 
      descricao: "Almoço do domingo", 
      data: "10/05/2025", 
      eDespesa: true, 
      categoria: Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant), 
      conta: null, 
      cartao: Cartao(
        nome: "Next",
        icone: Banco(nome: "Cartão", img: "Cartão"),
        limite: "500,00",
        diaFechamento: "08",
        diaVencimento: "15",
        conta:
          Conta(
            nome: "Next",
            saldo: "2.003,90",
            banco: Banco(img: "assets/next.jpg", nome: "Next")
          )),
    ),
    Lancamentos(
      valor: "1.600,00", 
      descricao: "Salário do mês de maio", 
      data: "31/05/2025", 
      eDespesa: false, 
      categoria: Categorias(nome: "Salário", cor: Colors.tealAccent.shade400, icon: Icons.star_rounded), 
      conta: Conta(nome: "Poupança", saldo: "8.500,00", banco: Banco(nome: "Cofrinho", img: "Cofrinho")),
      cartao: null
    ),
  ];

  List<Lancamentos> get lancamentos => _lancamentos; 
}
