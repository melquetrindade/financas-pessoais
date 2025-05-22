import 'package:financas_pessoais/model/categoria.dart';
import 'package:flutter/material.dart';

class RepositoryCategorias {
  final List<Categorias> _categoriasDespesa = [
    Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant),
    Categorias(
        nome: "Assinaturas e serviços", cor: Colors.purpleAccent.shade700, icon: Icons.credit_score),
    Categorias(nome: "Bares e restaurantes", cor: Colors.deepPurple.shade800, icon: Icons.wine_bar),
    Categorias(nome: "Casa ", cor: Colors.blue, icon: Icons.home_filled),
    Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined),
    Categorias(nome: "Cuidados pessoais", cor: Colors.deepOrange.shade400, icon: Icons.person),
    Categorias(nome: "Dívidas e empréstimos", cor: Colors.deepOrange.shade200, icon: Icons.receipt_long_outlined),
    Categorias(nome: "Educação", cor: Colors.blue.shade800, icon: Icons.school),
    Categorias(nome: "Família e filhos", cor: Colors.green, icon: Icons.family_restroom),
    Categorias(nome: "Impostos e Taxas", cor: Colors.deepOrange.shade200, icon: Icons.calculate_outlined),
    Categorias(nome: "Investimentos", cor: Colors.pink.shade300, icon: Icons.bar_chart_outlined),
    Categorias(nome: "Lazer e hobbies", cor: Colors.green, icon: Icons.emoji_emotions),
    Categorias(nome: "Mercado", cor: Colors.orange.shade400, icon: Icons.shopping_cart),
    Categorias(nome: "Outros", cor: Colors.green.shade700, icon: Icons.check),
    Categorias(nome: "Pets", cor: Colors.yellow.shade600, icon: Icons.pets),
    Categorias(nome: "Presentes e doações", cor: Colors.blue.shade600, icon: Icons.volunteer_activism),
    Categorias(nome: "Roupas", cor: Colors.red.shade800, icon: Icons.checkroom),
    Categorias(nome: "Saúde", cor: Colors.blue, icon: Icons.local_hospital_sharp),
    Categorias(nome: "Trabalho", cor: Colors.blue.shade800, icon: Icons.work_rounded),
    Categorias(nome: "Transporte", cor: Colors.blue.shade300, icon: Icons.bus_alert_sharp),
    Categorias(nome: "Viagem", cor: Colors.deepOrange.shade300, icon: Icons.airplanemode_active),
  ];

  final List<Categorias> _categoriasReceita = [
    Categorias(nome: "Empréstimos", cor: Colors.teal.shade400, icon: Icons.attach_money_outlined),
    Categorias(
        nome: "Investimentos", cor: Colors.tealAccent, icon: Icons.list_sharp),
    Categorias(nome: "Outras Receitas", cor: Colors.teal.shade700, icon: Icons.show_chart_sharp),
    Categorias(nome: "Salário", cor: Colors.tealAccent.shade400, icon: Icons.star_rounded)
  ];

  List<Categorias> get categoriasDespesas => _categoriasDespesa;
  List<Categorias> get categoriasReceitas => _categoriasReceita;
}
