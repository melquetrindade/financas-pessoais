import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/pages/contaPage.dart';
import 'package:financas_pessoais/pages/fluxoCaixaPage.dart';
import 'package:financas_pessoais/pages/gastosPage.dart';
import 'package:financas_pessoais/pages/home.dart';
import 'package:financas_pessoais/pages/relatorioPage.dart';
import 'package:flutter/material.dart';

class HomeControllerPage extends StatefulWidget {
  const HomeControllerPage({super.key});

  @override
  State<HomeControllerPage> createState() => _HomeControllerPageState();
}

class _HomeControllerPageState extends State<HomeControllerPage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pc,
          children: [
            Home(),
            FluxoCaixaPage(),
            ContasPage(),
            RelatoriosPage(),
            GastosPage()
          ],
          onPageChanged: setPaginaAtual,
        ),
        floatingActionButton: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () => pc.animateToPage(
              2, duration: Duration(milliseconds: 400), curve: Curves.ease
            ),
            shape: CircleBorder(),
            backgroundColor: AppColors.azulPrimario,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 60,
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: paginaAtual == 0 ? AppColors.azulPrimario : Colors.black,),
                onPressed: () => pc.animateToPage(
                  0, duration: Duration(milliseconds: 400), curve: Curves.ease
                ),
              ),
              IconButton(
                icon: Icon(Icons.loop, color: paginaAtual == 1 ? AppColors.azulPrimario : Colors.black,),
                onPressed: () => pc.animateToPage(
                  1, duration: Duration(milliseconds: 400), curve: Curves.ease
                ),
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                icon: Icon(Icons.bar_chart_rounded, color: paginaAtual == 3 ? AppColors.azulPrimario : Colors.black,),
                onPressed: () => pc.animateToPage(
                  3, duration: Duration(milliseconds: 400), curve: Curves.ease
                ),
              ),
              IconButton(
                icon: Icon(Icons.data_usage_outlined, color: paginaAtual == 4 ? AppColors.azulPrimario : Colors.black,),
                onPressed: () => pc.animateToPage(
                  4, duration: Duration(milliseconds: 400), curve: Curves.ease
                ),
              )
            ],
          ),
        ));
  }
}

/*
bottomNavigationBar: BottomNavigationBar(
  currentIndex: paginaAtual,
  type: BottomNavigationBarType.fixed,
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "teste"),
    BottomNavigationBarItem(icon: Icon(Icons.loop), label: "teste"),
    //BottomNavigationBarItem(icon: Icon(Icons.add), label: "teste"),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "teste"),
    BottomNavigationBarItem(icon: Icon(Icons.data_usage_outlined), label: "teste"),
  ],
  onTap: (pagina) {
    pc.animateToPage(
      pagina,
      duration: Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  },
),*/