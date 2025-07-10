import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:financas_pessoais/utils/mySnackBar.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditGastos extends StatefulWidget {
  final Gastos gasto;
  const EditGastos({super.key, required this.gasto});

  @override
  State<EditGastos> createState() => _EditGastosState();
}

class _EditGastosState extends State<EditGastos> {
  bool loading = false;
  bool loadingUpdate = false;
  final formKey = GlobalKey<FormState>();
  final saldo = TextEditingController();

  @override
  void initState() {
    super.initState();
    saldo.text = widget.gasto.limite;
    saldo.addListener(_formatSaldo);
  }

  void _formatSaldo() {
    String text = saldo.text;
    String onlyDigits = text.replaceAll(RegExp(r'[^\d]'), '');

    if (onlyDigits.isEmpty) {
      saldo.value = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    double value = double.parse(onlyDigits) / 100;
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    String newText = formatter.format(value).trim();

    saldo.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  feedback(bool sinal, String message) {
    if (sinal) {
      MySnackBar.mensagem(
          'OK',
          Colors.green,
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          message,
          context);
    }
  }

  deleteGasto(Gastos gasto) async {
    setState(() => loading = true);
    try {
      await context.read<RepositoryGastos>().removeGasto(gasto, feedback);
      setState(() => loading = false);
    } on AuthException catch (e) {
      setState(() => loading = false);
      MySnackBar.mensagem(
          'OK',
          Colors.red,
          Icon(
            Icons.close,
            color: Colors.white,
          ),
          e.message,
          context);
    }
    Navigator.pop(context);
  }

  updateGasto(Gastos gasto) async {
    setState(() => loadingUpdate = true);
    try {
      await context.read<RepositoryGastos>().updateGasto(gasto, feedback);
      setState(() => loadingUpdate = false);
    } on AuthException catch (e) {
      setState(() => loadingUpdate = false);
      MySnackBar.mensagem(
          'OK',
          Colors.red,
          Icon(
            Icons.close,
            color: Colors.white,
          ),
          e.message,
          context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Editar limite de gastos",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: (loading)
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        print("excluir limite de gastos");
                        deleteGasto(widget.gasto);
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      )),
            )
          ],
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
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Gasto",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                                width: 35,
                                height: 35,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: widget.gasto.categoria.cor,
                                    child: Icon(
                                      widget.gasto.categoria.icon,
                                      color: Colors.white,
                                    ))),
                            SizedBox(width: 8),
                            Text(
                              widget.gasto.categoria.nome,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Limite",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      TextFormField(
                          controller: saldo,
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
                          if (formKey.currentState!.validate()) {
                            // update gasto
                            print("atualiza o limite");
                            updateGasto(Gastos(
                                categoria: Categorias(
                                    nome: widget.gasto.categoria.nome,
                                    cor: widget.gasto.categoria.cor,
                                    icon: widget.gasto.categoria.icon),
                                valor: widget.gasto.valor,
                                limite: saldo.text,
                                data: widget.gasto.data));
                          } else {
                            MySnackBar.mensagem(
                                'OK',
                                Colors.red,
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                'Erro, preencha corretamente as informações!',
                                context);
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
                        child: loadingUpdate
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.azulPrimario,
                                  ),
                                ),
                              )
                            : Text("Salvar alterações")),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
