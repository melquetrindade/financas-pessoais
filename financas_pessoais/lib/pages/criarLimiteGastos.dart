import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:financas_pessoais/repository/categorias.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:financas_pessoais/utils/mySnackBar.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CriarLimiteGastosPage extends StatefulWidget {
  const CriarLimiteGastosPage({super.key});

  @override
  State<CriarLimiteGastosPage> createState() => _CriarLimiteGastosPageState();
}

class _CriarLimiteGastosPageState extends State<CriarLimiteGastosPage> {
  late RepositoryCategorias repositoryCategorias;
  late List<Categorias> listaCategorias;
  final formKey = GlobalKey<FormState>();
  final limite = TextEditingController();
  Categorias categotiaEscolhida =
      Categorias(nome: "", cor: Colors.blue, icon: Icons.add);

  @override
  void initState() {
    super.initState();
    limite.addListener(_formatSaldo);
  }

  void _formatSaldo() {
    String text = limite.text;
    String onlyDigits = text.replaceAll(RegExp(r'[^\d]'), '');

    if (onlyDigits.isEmpty) {
      limite.value = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }
    double value = double.parse(onlyDigits) / 100;
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    String newText = formatter.format(value).trim();

    limite.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  @override
  void dispose() {
    limite.removeListener(_formatSaldo);
    limite.dispose();
    super.dispose();
  }

  void mostrarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.93,
          minChildSize: 0.3,
          maxChildSize: 0.93,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: modalCategorias(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String obterDataAtualFormatada() {
    final agora = DateTime.now();

    String dia = agora.day.toString().padLeft(2, '0');
    String mes = agora.month.toString().padLeft(2, '0');
    String ano = agora.year.toString();

    return "$dia/$mes/$ano";
  }

  feedback(bool sinal) {
    if (sinal) {
      MySnackBar.mensagem(
          'OK',
          Colors.green,
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          'Limite de gasto criado com sucesso!',
          context);
      context.read<RepositoryGastos>().notifica();
    } else {
      MySnackBar.mensagem(
          'OK',
          Colors.red,
          Icon(
            Icons.close,
            color: Colors.white,
          ),
          'Você já possui um limite de gasto com essa categoria para este mês!',
          context);
      context.read<RepositoryGastos>().notifica();
    }
  }

  addGasto(Gastos gasto) {
    context.read<RepositoryGastos>().saveGasto(gasto, feedback);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    repositoryCategorias = RepositoryCategorias();
    listaCategorias = repositoryCategorias.categoriasDespesas;

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Criar limite de gastos",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 7),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Escolha uma categoria",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mostrarModal(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: 37,
                                height: 37,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        categotiaEscolhida.nome == ""
                                            ? AppColors.azulPrimario
                                            : categotiaEscolhida.cor,
                                    child: categotiaEscolhida.nome == ""
                                        ? Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            categotiaEscolhida.icon,
                                            color: Colors.white,
                                          )),
                              ),
                            ),
                            Text(
                              categotiaEscolhida.nome == ""
                                  ? "Selecione uma categoria"
                                  : categotiaEscolhida.nome,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 7),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Defina um limite",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      TextFormField(
                          controller: limite,
                          decoration: InputDecoration(
                            hintText: '0,00',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 12, top: 12),
                              child: Text(
                                'R\$',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validador.validatorSaldoConta(value)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          print("Cadastrar");
                          if (formKey.currentState!.validate() &&
                              categotiaEscolhida.nome != "") {
                            print("tudo ok");
                            print(
                                "dados => Categoria: ${categotiaEscolhida.nome} - limite: ${limite.text} - data: ${obterDataAtualFormatada}");
                            addGasto(Gastos(
                                categoria: Categorias(
                                    nome: categotiaEscolhida.nome,
                                    cor: categotiaEscolhida.cor,
                                    icon: categotiaEscolhida.icon),
                                valor: "0,00",
                                limite: limite.text,
                                data: obterDataAtualFormatada()));
                          } else {
                            if (categotiaEscolhida.nome == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erro, selecione uma categoria para prosseguir!'),
                                  duration: Duration(seconds: 10),
                                ),
                              );
                            }
                            print("error");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.azulPrimario,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: AppColors.azulPrimario,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text("Criar limite")),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget modalCategorias() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black,
          ),
          height: 3,
          width: 130,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          child: Text(
            'Selecione uma categoria',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
        ),
        for (var i = 0; i < listaCategorias.length; i++) iconesCategorias(i),
      ],
    );
  }

  Widget iconesCategorias(int i) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              categotiaEscolhida = listaCategorias[i];
            });
            print(listaCategorias[i].nome);
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: listaCategorias[i].cor,
                  child: Icon(
                    listaCategorias[i].icon,
                    color: Colors.white,
                  ),
                )),
            title: Text(
              listaCategorias[i].nome,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        )
      ],
    );
  }
}
