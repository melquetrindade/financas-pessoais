import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/categorias.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financas_pessoais/model/categoria.dart';

class LancamentosPage extends StatefulWidget {
  const LancamentosPage({super.key});

  @override
  State<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends State<LancamentosPage> {
  late RepositoryCategorias repositoryCategorias;
  late RepositoryContas repositoryContas;
  late RepositoryCartao repositoryCartao;
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final descricao = TextEditingController();
  bool eDespesa = true;
  Categorias categoriaEscolhida = Categorias(
      nome: "", cor: Colors.deepPurple.shade800, icon: Icons.wine_bar);
  Conta contaEscolhida =
      Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: "");
  Cartao cartaoEscolhido = Cartao(
      nome: "",
      icone: Banco(nome: "", img: ""),
      limite: "",
      diaFechamento: "",
      diaVencimento: "",
      fatura: "",
      conta: Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: ""));

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
                  child: modal(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  AssetImage? setBackgroundPag() {
    if (contaEscolhida.nome != "" || cartaoEscolhido.nome != "") {
      if (contaEscolhida.nome != "") {
        return AssetImage(contaEscolhida.banco.img);
      }
      return AssetImage(cartaoEscolhido.icone.img);
    }
    return null;
  }

  String setNomePag() {
    if (contaEscolhida.nome != "" || cartaoEscolhido.nome != "") {
      if (contaEscolhida.nome != "") {
        return contaEscolhida.nome;
      }
      return cartaoEscolhido.nome;
    }
    return "Bancos e Cartões";
  }

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

  List<Categorias> listaDeCategorias() {
    return eDespesa
        ? repositoryCategorias.categoriasDespesas
        : repositoryCategorias.categoriasReceitas;
  }

  @override
  Widget build(BuildContext context) {
    repositoryCategorias = RepositoryCategorias();
    repositoryContas = RepositoryContas();
    repositoryCartao = RepositoryCartao();

    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: eDespesa ? Colors.red.shade400 : Colors.green,
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
                                      color: eDespesa
                                          ? Colors.white
                                          : Colors.white60,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 20,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: eDespesa
                                            ? Colors.white
                                            : Colors.white60,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                eDespesa = !eDespesa;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Receita",
                                  style: TextStyle(
                                      color: eDespesa
                                          ? Colors.white60
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 20,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: eDespesa
                                            ? Colors.white60
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                child: Icon(
                                  eDespesa
                                      ? Icons.thumb_down_alt_rounded
                                      : Icons.thumb_up_alt_rounded,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Descrição",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: descricao,
                        decoration: InputDecoration(
                          hintText: 'Adicione a descrição',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 17),
                            child: SizedBox(
                              width: 37,
                              height: 37,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.azulPrimario,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 47,
                            minHeight: 47,
                          ),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Categoria",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Abrir modal de categorias");
                          mostrarModal(context);
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 37,
                            height: 37,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: categoriaEscolhida.nome == ""
                                  ? AppColors.azulPrimario
                                  : categoriaEscolhida.cor,
                              child: categoriaEscolhida.nome == ""
                                  ? Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      categoriaEscolhida.icon,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          title: Text(
                            categoriaEscolhida.nome == ""
                                ? "Selecione uma categoria"
                                : categoriaEscolhida.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Pago com",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Abrir modal com bancos e cartões");
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 37,
                            height: 37,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundImage: setBackgroundPag(),
                                backgroundColor: setBackgroundPag() == null
                                    ? AppColors.azulPrimario
                                    : null,
                                child: setBackgroundPag() == null
                                    ? Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )
                                    : null),
                          ),
                          title: Text(
                            setNomePag(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Data",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Abrir calendário");
                          selecionarData(context);
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 37,
                            height: 37,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: null,
                              backgroundColor: AppColors.azulPrimario,
                              child: Icon(
                                Icons.date_range_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            "Hoje",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                                side: BorderSide(
                                  color: Colors.green,
                                  width: 1,
                                ),
                              ),
                            ),
                            onPressed: () {
                              print("Confitmar lançamento");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Confirmar Lançamento',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget modal() {
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
        for (var i = 0; i < listaDeCategorias().length; i++)
          iconesCategorias(i, listaDeCategorias()),
      ],
    );
  }

  Widget iconesCategorias(int i, List<Categorias> categorias) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              categoriaEscolhida.nome = categorias[i].nome;
              categoriaEscolhida.cor = categorias[i].cor;
              categoriaEscolhida.icon = categorias[i].icon;
            });
            print(categorias[i].nome);
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: categorias[i].cor,
                  child: Icon(categorias[i].icon, color: Colors.white,),
                )),
            title: Text(
              categorias[i].nome,
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
