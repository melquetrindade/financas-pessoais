import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LancamentosPage extends StatefulWidget {
  const LancamentosPage({super.key});

  @override
  State<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends State<LancamentosPage> {
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  bool eDespesa = true;

  void _formatValor() {
    String text = valor.text;
    String onlyDigits = text.replaceAll(RegExp(r'[^\d]'), '');

    if (onlyDigits.isEmpty) {
      valor.value = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }
    double value = double.parse(onlyDigits) / 100;
    const double maxValue = 1000000.00;

    if (value > maxValue) {
      value = maxValue;
    }

    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    String newText = formatter.format(value).trim();

    valor.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  @override
  void initState() {
    super.initState();
    valor.addListener(_formatValor);
  }

  Future<void> selecionarData(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('pt', 'BR'),
    );

    if (dataSelecionada != null) {
      print('Data escolhida: $dataSelecionada');
    } else {
      print('O usuário cancelou a seleção.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: eDespesa ?Colors.red.shade400 : Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                eDespesa = !eDespesa;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Despesa",
                                  style: TextStyle(
                                      color: eDespesa ? Colors.white : Colors.white60,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 20,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: eDespesa ? Colors.white : Colors.white60,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                eDespesa = !eDespesa;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Receita",
                                  style: TextStyle(
                                      color: eDespesa ?Colors.white60 : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 20,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: eDespesa ?Colors.white60 : Colors.white,
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 119,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                    controller: valor,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0,00',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 40),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.number),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Icon(eDespesa ? Icons.thumb_down_alt_rounded : Icons.thumb_up_alt_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
IconButton(
            onPressed: () async {
              selecionarData(context);
            },
            icon: Icon(Icons.date_range_outlined))
 */