import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:flutter/material.dart';

class RepositoryGastos {
  List<Gastos> _gastos = [
    Gastos(
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined),
      valor: "250,00", 
      limite: "500,00", 
      data: "18/06/2025"),
    Gastos(
      categoria: Categorias(nome: "Alimentação", cor: Colors.pink.shade400, icon: Icons.restaurant), 
      valor: "750,00", 
      limite: "700,00", 
      data: "07/06/2025"),
    Gastos(
      categoria: Categorias(nome: "Lazer e hobbies", cor: Colors.green, icon: Icons.emoji_emotions),
      valor: "150,00", 
      limite: "200,00", 
      data: "16/06/2025"),
    Gastos(
      categoria: Categorias(nome: "Viagem", cor: Colors.deepOrange.shade300, icon: Icons.airplanemode_active),
      valor: "50,00", 
      limite: "1000,00", 
      data: "01/02/2025"),
    Gastos(
      categoria: Categorias(nome: "Compras ", cor: Colors.pink, icon: Icons.shopping_bag_outlined), 
      valor: "350,00", 
      limite: "700,00", 
      data: "01/02/2025"),
    Gastos(
      categoria: Categorias(nome: "Presentes e doações", cor: Colors.blue.shade600, icon: Icons.volunteer_activism),
      valor: "100,00", 
      limite: "200,00", 
      data: "16/12/2024"),
  ];

  List<Gastos> get gastos => _gastos;
}
