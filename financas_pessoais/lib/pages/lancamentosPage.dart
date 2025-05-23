import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/categorias.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/utils/validador.dart';
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
  DateTime? data;
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

  void mostrarModal(BuildContext context, int tipoModal) {
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
                  child:
                      tipoModal == 0 ? modalCategorias() : modalContasCartoes(),
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
        if (contaEscolhida.banco.img == "Carteira" ||
            contaEscolhida.banco.img == "Cofrinho" ||
            contaEscolhida.banco.img == "Banco") {
          return null;
        }
        return AssetImage(contaEscolhida.banco.img);
      }
      if (cartaoEscolhido.icone.img == "Cartão") {
        return null;
      }
      return AssetImage(cartaoEscolhido.icone.img);
    }
    return null;
  }

  bool setBackgroundColorPag() {
    if (contaEscolhida.nome == "" && cartaoEscolhido.nome == "") {
      return true;
    }
    if (contaEscolhida.nome != "" || cartaoEscolhido.nome != "") {
      if (contaEscolhida.nome != "") {
        if (contaEscolhida.banco.img == "Carteira" ||
            contaEscolhida.banco.img == "Cofrinho" ||
            contaEscolhida.banco.img == "Banco") {
          return true;
        }
        return false;
      }
      if (cartaoEscolhido.icone.img == "Cartão") {
        return true;
      }
      return false;
    }
    return false;
  }

  Icon? setIconPag() {
    if (contaEscolhida.nome != "" || cartaoEscolhido.nome != "") {
      if (contaEscolhida.nome != "") {
        if (contaEscolhida.banco.img == "Cofrinho") {
          return Icon(
            Icons.savings,
            color: Colors.white,
          );
        }
        if (contaEscolhida.banco.img == "Carteira") {
          return Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
          );
        }
        if (contaEscolhida.banco.img == "Banco") {
          return Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
          );
        }
        return null;
      }
      if (cartaoEscolhido.icone.img == "Cartão") {
        return Icon(
          Icons.credit_card,
          color: Colors.white,
        );
      }
      return null;
    }
    if (contaEscolhida.nome == "" && cartaoEscolhido.nome == "") {
      return Icon(
        Icons.add,
        color: Colors.white,
      );
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
      setState(() {
        data = dataSelecionada;
      });
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
                        validator: (value) =>
                            Validador.validatorNomeCartao(value),
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
                          mostrarModal(context, 0);
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
                          mostrarModal(context, 1);
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 37,
                            height: 37,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundImage: setBackgroundPag(),
                                backgroundColor: setBackgroundColorPag()
                                    ? AppColors.azulPrimario
                                    : null,
                                child: setIconPag()),
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
                              if (formKey.currentState!.validate() &&
                                  categoriaEscolhida.nome != "" &&
                                  data != null &&
                                  (contaEscolhida.nome != "" ||
                                      cartaoEscolhido.nome != "")) {
                                print("tudo ok");
                                print(
                                    "dados do lançamento: \t\n Valor: ${valor.text} \t\n Descrição: ${descricao.text} \t\n Categoria: ${categoriaEscolhida.nome} \t\n Pago com: ${contaEscolhida.nome != "" ? contaEscolhida.nome : cartaoEscolhido.nome} \t\n Data: ${data}");
                              } else {
                                /*
                                if (infoBanco.img == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Erro, selecione um ícone para prosseguir!'),
                                      duration: Duration(seconds: 10),
                                    ),
                                  );
                                }*/
                                print("error");
                              }
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
        for (var i = 0; i < listaDeCategorias().length; i++)
          iconesCategorias(i, listaDeCategorias()),
      ],
    );
  }

  Widget modalContasCartoes() {
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
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'Selecione uma conta ou cartão de crédito',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Suas contas bancárias",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
        for (var i = 0; i < repositoryContas.contas.length; i++)
          iconesContasCartoes(i, true),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Seus cartões de crédito",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
        for (var i = 0; i < repositoryCartao.cartoes.length; i++)
          iconesContasCartoes(i, false),
      ],
    );
  }

  Widget iconesCategorias(int i, List<Categorias> categorias) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              categoriaEscolhida = categorias[i];
              /*
              categoriaEscolhida.nome = categorias[i].nome;
              categoriaEscolhida.cor = categorias[i].cor;
              categoriaEscolhida.icon = categorias[i].icon;*/
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
                  child: Icon(
                    categorias[i].icon,
                    color: Colors.white,
                  ),
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

  Widget iconesContasCartoes(int i, bool eConta) {
    void setValores() {
      if (eConta) {
        setState(() {
          contaEscolhida = repositoryContas.contas[i];
          cartaoEscolhido = Cartao(
              nome: "",
              icone: Banco(nome: "", img: ""),
              limite: "",
              diaFechamento: "",
              diaVencimento: "",
              fatura: "",
              conta:
                  Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: ""));
        });
      } else {
        setState(() {
          cartaoEscolhido = repositoryCartao.cartoes[i];
          contaEscolhida =
              Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: "");
        });
      }
    }

    bool temImg() {
      if (eConta) {
        if (repositoryContas.contas[i].banco.img == "Cofrinho" ||
            repositoryContas.contas[i].banco.img == "Carteira" ||
            repositoryContas.contas[i].banco.img == "Banco") {
          return false;
        }
        return true;
      }
      if (repositoryCartao.cartoes[i].icone.img == "Cartão") {
        return false;
      }
      return true;
    }

    AssetImage? imgContaCartao() {
      if (eConta) {
        if (repositoryContas.contas[i].banco.img == "Cofrinho" ||
            repositoryContas.contas[i].banco.img == "Carteira" ||
            repositoryContas.contas[i].banco.img == "Banco") {
          return null;
        }
        return AssetImage(repositoryContas.contas[i].banco.img);
      }
      if (repositoryCartao.cartoes[i].icone.img == "Cartão") {
        return null;
      }
      return AssetImage(repositoryCartao.cartoes[i].icone.img);
    }

    Icon? iconContaCartao() {
      if (eConta) {
        if (repositoryContas.contas[i].banco.img == "Cofrinho" ||
            repositoryContas.contas[i].banco.img == "Carteira" ||
            repositoryContas.contas[i].banco.img == "Banco") {
          if (repositoryContas.contas[i].banco.img == "Cofrinho") {
            return Icon(
              Icons.savings,
              color: Colors.white,
            );
          }
          if (repositoryContas.contas[i].banco.img == "Carteira") {
            return Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
            );
          }
          return Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
          );
        }
        return null;
      }
      if (repositoryCartao.cartoes[i].icone.img == "Cartão") {
        return Icon(
          Icons.credit_card,
          color: Colors.white,
        );
      }
      return null;
    }

    String nomeContaCartao() {
      if (eConta) {
        return repositoryContas.contas[i].nome;
      }
      return repositoryCartao.cartoes[i].nome;
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            setValores();
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                    radius: 15,
                    backgroundColor: temImg() ? null : AppColors.azulPrimario,
                    backgroundImage: imgContaCartao(),
                    child: iconContaCartao())),
            title: Text(
              nomeContaCartao(),
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
