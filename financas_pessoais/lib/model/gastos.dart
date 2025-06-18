import 'package:financas_pessoais/model/categoria.dart';

class Gastos {
  Categorias categoria;
  String limite;
  String valor;
  String data;

  Gastos({required this.categoria, required this.valor, required this.limite, required this.data});
}
