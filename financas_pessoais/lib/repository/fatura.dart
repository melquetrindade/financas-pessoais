import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:flutter/material.dart';

class RepositoryFatura {
  final List<Fatura> _faturas = [
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "500,00",
            descricao: "Aluguel",
            data: "02/05/2025",
            eDespesa: false,
            categoria: Categorias(
                nome: "Outras Receitas",
                cor: Colors.teal.shade700,
                icon: Icons.show_chart_sharp),
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
            valor: "100,00",
            descricao: "Compra de Fone",
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
            valor: "585,00",
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
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
            limite: "1.000,00",
            diaFechamento: "01",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "01/03/205", valor: "-185,00")],
        data: "23/02/2025",
        foiPago: true),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "200,00",
            descricao: "Controle do PS4",
            data: "02/12/2024",
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
            data: "23/12/2024",
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
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
            limite: "1.000,00",
            diaFechamento: "01",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "30/04/205", valor: "-350,00")],
        data: "02/12/2024",
        foiPago: true),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "1.000,00",
            descricao: "Console PS4",
            data: "12/06/2025",
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
            valor: "15,00",
            descricao: "Dogão",
            data: "16/06/2025",
            eDespesa: true,
            categoria: Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant),
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
            valor: "500,00",
            descricao: "Venda dos Notebooks",
            data: "01/06/2025",
            eDespesa: false,
            categoria: Categorias(nome: "Outras Receitas", cor: Colors.teal.shade700, icon: Icons.show_chart_sharp),
            conta: null,
            cartao: Cartao(
                nome: "Banco do Brasil",
                icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
                limite: "1.000,00",
                diaFechamento: "31",
                diaVencimento: "30",
                conta: Conta(
                    nome: "Banco do Brasil",
                    saldo: "1.567,90",
                    banco:
                        Banco(img: "assets/bb.png", nome: "Banco do Brasil"))),
          ),
        ],
        cartao: Cartao(
            nome: "Banco do Brasil",
            icone: Banco(nome: "Banco do Brasil", img: "assets/bb.png"),
            limite: "1.000,00",
            diaFechamento: "31",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco do Brasil",
                saldo: "1.567,90",
                banco: Banco(img: "assets/bb.png", nome: "Banco do Brasil"))),
        pagamentos: [Pagamentos(data: "14/06/205", valor: "-1.000,00"), Pagamentos(data: "14/06/205", valor: "485,00")],
        data: "12/06/2025",
        foiPago: true),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "500,00",
            descricao: "Aluguel",
            data: "02/02/2025",
            eDespesa: false,
            categoria: Categorias(
                nome: "Outras Receitas",
                cor: Colors.teal.shade700,
                icon: Icons.show_chart_sharp),
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
            valor: "100,00",
            descricao: "Compra de Fone",
            data: "23/02/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
            valor: "585,00",
            descricao: "Fifa 25",
            data: "23/02/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
        ],
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
        pagamentos: [],
        data: "23/02/2025",
        foiPago: false),
    Fatura(
        lancamentos: [
          Lancamentos(
            valor: "200,00",
            descricao: "Controle do PS4",
            data: "01/06/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
            descricao: "Compra do Red Dead",
            data: "01/06/2025",
            eDespesa: true,
            categoria: Categorias(
                nome: "Compras ",
                cor: Colors.pink,
                icon: Icons.shopping_bag_outlined),
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
        ],
        cartao: Cartao(
        nome: "Banco PAN",
        icone: Banco(nome: "Banco PAN", img: "assets/pan.png"),
        limite: "500,00",
        diaFechamento: "30",
        diaVencimento: "30",
        conta: Conta(
            nome: "Banco PAN", 
            saldo: "10.000,00",
            banco: Banco(img: "assets/pan.png", nome: "Banco PAN")
        )),
        pagamentos: [Pagamentos(data: "01/06/2025", valor: "-200,00")],
        data: "01/05/2025",
        foiPago: false),
        Fatura(
            lancamentos: [
            Lancamentos(
                valor: "200,00",
                descricao: "Controle do PS4",
                data: "01/06/2025",
                eDespesa: true,
                categoria: Categorias(
                    nome: "Compras ",
                    cor: Colors.pink,
                    icon: Icons.shopping_bag_outlined),
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
                descricao: "Compra do Red Dead",
                data: "02/06/2025",
                eDespesa: true,
                categoria: Categorias(
                    nome: "Compras ",
                    cor: Colors.pink,
                    icon: Icons.shopping_bag_outlined),
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
            ],
            cartao: Cartao(
            nome: "Banco PAN",
            icone: Banco(nome: "Banco PAN", img: "assets/pan.png"),
            limite: "500,00",
            diaFechamento: "30",
            diaVencimento: "30",
            conta: Conta(
                nome: "Banco PAN", 
                saldo: "10.000,00",
                banco: Banco(img: "assets/pan.png", nome: "Banco PAN")
            )),
            pagamentos: [],
            data: "02/06/2025",
            foiPago: false),
  ];

  List<Fatura> get faturas => _faturas;
}
