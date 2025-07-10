import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/model/fatura.dart';
import 'package:financas_pessoais/model/gastos.dart';
import 'package:financas_pessoais/model/lancamentos.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/categorias.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:financas_pessoais/utils/mySnackBar.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financas_pessoais/model/categoria.dart';
import 'package:provider/provider.dart';

class LancamentosPage extends StatefulWidget {
  const LancamentosPage({super.key});

  @override
  State<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends State<LancamentosPage> {
  late RepositoryCategorias repositoryCategorias;
  late RepositoryContas repositoryContas;
  late RepositoryFatura repositoryFatura;
  late RepositoryGastos repositoryGastos;
  late List<Conta> listaContas = [];
  late RepositoryCartao repositoryCartao;
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final descricao = TextEditingController();
  bool loading = false;
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

  bool formatValor(String valorTexto) {
    if (valorTexto != "") {
      String valorFormt = valorTexto.replaceAll('.', '').replaceAll(',', '.');
      double valorNumber = double.parse(valorFormt);
      if (valorNumber > 0) {
        return true;
      }
      return false;
    }
    return false;
  }

  String extrairMesEAno(String data) {
    List<String> partes = data.split('/');
    if (partes.length != 3) throw FormatException('Data inválida');
    String mes = partes[1];
    String ano = partes[2];
    return '$mes/$ano';
  }

  String extrairMesEAno2(String dataCompleta) {
    List<String> partes = dataCompleta.split("/");
    String mes = partes[1];
    String ano = partes[2];
    return "$mes/$ano";
  }

  Gastos? hasLimiteGastos(Lancamentos lancamento) {
    List<Gastos> gastos = repositoryGastos.gastos;
    Gastos? gasto;
    gastos.forEach((item) {
      if (extrairMesEAno2(item.data) == extrairMesEAno2(lancamento.data) &&
          lancamento.categoria.nome == item.categoria.nome) {
        gasto = item;
      }
    });
    if (gasto != null) {
      return gasto;
    }
    return null;
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

  addLancamento(Lancamentos lancamento) async {
    setState(() => loading = true);
    Gastos? gasto = hasLimiteGastos(lancamento);
    try {
      await context
          .read<RepositoryLancamentos>()
          .saveLancamento(lancamento, feedback);
      if (gasto != null && lancamento.eDespesa) {
        print("Entrou para chamar o update valor do gasto");
        context
            .read<RepositoryGastos>()
            .updateSaldoGasto(gasto, lancamento.valor);
      }
      setState(() {
        loading = false;
        valor.text = "";
        descricao.text = "";
        categoriaEscolhida = Categorias(
            nome: "", cor: Colors.deepPurple.shade800, icon: Icons.wine_bar);
        contaEscolhida =
            Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: "");
        cartaoEscolhido = Cartao(
            nome: "",
            icone: Banco(nome: "", img: ""),
            limite: "",
            diaFechamento: "",
            diaVencimento: "",
            conta: Conta(nome: "", banco: Banco(nome: "", img: ""), saldo: ""));
        data = null;
      });
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
  }

  addFatura(Fatura fatura) {
    context.read<RepositoryFatura>().saveFaturas(fatura);
    addLancamento(fatura.lancamentos[0]);
  }

  updateSaldoConta(
      Conta conta, String valor, bool eDespesa, Lancamentos lancamento) {
    context.read<RepositoryContas>().updateSaldo(conta, valor, eDespesa);
    addLancamento(lancamento);
  }

  updateFatura(Fatura? fatura, Lancamentos lancamento) {
    context.read<RepositoryFatura>().updateFatura(fatura, lancamento);
    addLancamento(lancamento);
  }

  String formatarData(String dataOriginal) {
    DateTime data = DateTime.parse(dataOriginal);

    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String ano = data.year.toString();

    return '$dia/$mes/$ano';
  }

  @override
  Widget build(BuildContext context) {
    repositoryGastos = context.watch<RepositoryGastos>();
    repositoryCategorias = RepositoryCategorias();
    repositoryContas = context.watch<RepositoryContas>();
    repositoryCartao = context.watch<RepositoryCartao>();
    repositoryFatura = context.watch<RepositoryFatura>();
    listaContas = repositoryContas.contas;

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
                                categoriaEscolhida = Categorias(
                                    nome: "",
                                    cor: Colors.deepPurple.shade800,
                                    icon: Icons.wine_bar);
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
                                categoriaEscolhida = Categorias(
                                    nome: "",
                                    cor: Colors.deepPurple.shade800,
                                    icon: Icons.wine_bar);
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
                        //height: 119,
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
                            eDespesa ? "Pago com" : "Recebido com",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
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
                            data == null
                                ? "Selecione a data"
                                : "${data!.day}/${data!.month}/${data!.year}",
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
                              if (formKey.currentState!.validate() &&
                                  categoriaEscolhida.nome != "" &&
                                  data != null &&
                                  formatValor(valor.text) &&
                                  (contaEscolhida.nome != "" ||
                                      cartaoEscolhido.nome != "")) {
                                if (contaEscolhida.nome != "") {
                                  if (eDespesa) {
                                    if (possuiSaldo()) {
                                      updateSaldoConta(
                                          contaEscolhida,
                                          valor.text,
                                          true,
                                          Lancamentos(
                                              valor: valor.text,
                                              descricao: descricao.text,
                                              data: formatarData("${data!}"),
                                              eDespesa: eDespesa,
                                              categoria: categoriaEscolhida,
                                              conta: contaEscolhida.nome != ""
                                                  ? contaEscolhida
                                                  : null,
                                              cartao: cartaoEscolhido.nome != ""
                                                  ? cartaoEscolhido
                                                  : null));
                                    } else {
                                      MySnackBar.mensagem(
                                          'OK',
                                          Colors.red,
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          'Você não possui saldo suficiente na conta!',
                                          context);
                                    }
                                  } else {
                                    updateSaldoConta(
                                        contaEscolhida,
                                        valor.text,
                                        false,
                                        Lancamentos(
                                            valor: valor.text,
                                            descricao: descricao.text,
                                            data: formatarData("${data!}"),
                                            eDespesa: eDespesa,
                                            categoria: categoriaEscolhida,
                                            conta: contaEscolhida.nome != ""
                                                ? contaEscolhida
                                                : null,
                                            cartao: cartaoEscolhido.nome != ""
                                                ? cartaoEscolhido
                                                : null));
                                  }
                                } else {
                                  Fatura? fatura;
                                  repositoryFatura.faturas.forEach((item) {
                                    if (extrairMesEAno(item.data) ==
                                            extrairMesEAno(
                                                formatarData("${data!}")) &&
                                        item.cartao.nome ==
                                            cartaoEscolhido.nome) {
                                      print('fatura encontrada: ${item.data}');
                                      fatura = item;
                                    }
                                  });
                                  if (fatura != null) {
                                    if (eDespesa) {
                                      if (possuiSaldoCartao(fatura)) {
                                        updateFatura(
                                            fatura,
                                            Lancamentos(
                                                valor: valor.text,
                                                descricao: descricao.text,
                                                data: formatarData("${data!}"),
                                                eDespesa: eDespesa,
                                                categoria: categoriaEscolhida,
                                                conta: contaEscolhida.nome != ""
                                                    ? contaEscolhida
                                                    : null,
                                                cartao:
                                                    cartaoEscolhido.nome != ""
                                                        ? cartaoEscolhido
                                                        : null));
                                      } else {
                                        MySnackBar.mensagem(
                                            'OK',
                                            Colors.red,
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                            'Erro, você não tem saldo suficiente!',
                                            context);
                                      }
                                    } else {
                                      print("chama o updateFatura");
                                      updateFatura(
                                          fatura,
                                          Lancamentos(
                                              valor: valor.text,
                                              descricao: descricao.text,
                                              data: formatarData("${data!}"),
                                              eDespesa: eDespesa,
                                              categoria: categoriaEscolhida,
                                              conta: contaEscolhida.nome != ""
                                                  ? contaEscolhida
                                                  : null,
                                              cartao: cartaoEscolhido.nome != ""
                                                  ? cartaoEscolhido
                                                  : null));
                                    }
                                  } else {
                                    if (eDespesa) {
                                      if (possuiSaldoCartao2(cartaoEscolhido)) {
                                        addFatura(Fatura(
                                            lancamentos: [
                                              Lancamentos(
                                                  valor: valor.text,
                                                  descricao: descricao.text,
                                                  data:
                                                      formatarData("${data!}"),
                                                  eDespesa: eDespesa,
                                                  categoria: categoriaEscolhida,
                                                  conta:
                                                      contaEscolhida.nome != ""
                                                          ? contaEscolhida
                                                          : null,
                                                  cartao:
                                                      cartaoEscolhido.nome != ""
                                                          ? cartaoEscolhido
                                                          : null)
                                            ],
                                            cartao: cartaoEscolhido,
                                            pagamentos: [],
                                            data: formatarData("${data!}"),
                                            foiPago: false));
                                      } else {
                                        MySnackBar.mensagem(
                                            'OK',
                                            Colors.red,
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                            'Erro, você não tem saldo suficiente!',
                                            context);
                                      }
                                    } else {
                                      addFatura(Fatura(
                                          lancamentos: [
                                            Lancamentos(
                                                valor: valor.text,
                                                descricao: descricao.text,
                                                data: formatarData("${data!}"),
                                                eDespesa: eDespesa,
                                                categoria: categoriaEscolhida,
                                                conta: contaEscolhida.nome != ""
                                                    ? contaEscolhida
                                                    : null,
                                                cartao:
                                                    cartaoEscolhido.nome != ""
                                                        ? cartaoEscolhido
                                                        : null)
                                          ],
                                          cartao: cartaoEscolhido,
                                          pagamentos: [],
                                          data: formatarData("${data!}"),
                                          foiPago: false));
                                    }
                                  }
                                }
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
                            child: loading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Confirmar Lançamento',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
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

  bool possuiSaldo() {
    Conta conta = listaContas.firstWhere((c) => c.nome == contaEscolhida.nome);
    String valorFormt = conta.saldo.replaceAll('.', '').replaceAll(',', '.');
    double valorConta = double.parse(valorFormt);

    String valorLancFormt = valor.text.replaceAll('.', '').replaceAll(',', '.');
    double valorLanc = double.parse(valorLancFormt);

    if (valorConta >= valorLanc) {
      return true;
    }
    return false;
  }

  double moduloNum(double valor) {
    if (valor >= 0) {
      return valor;
    }
    return valor * (-1);
  }

  bool possuiSaldoCartao(Fatura? fatura) {
    String limiteCartao = fatura!.cartao.limite;
    if (fatura.foiPago) {
      String valorLancFormt =
          valor.text.replaceAll('.', '').replaceAll(',', '.');
      double valorLanc = double.parse(valorLancFormt);

      String limiteFormt =
          limiteCartao.replaceAll('.', '').replaceAll(',', '.');
      double limite = double.parse(limiteFormt);

      if (limite >= valorLanc) {
        return true;
      }
      return false;
    }
    String valorLancFormt = valor.text.replaceAll('.', '').replaceAll(',', '.');
    double valorLanc = double.parse(valorLancFormt);

    double despesaTotal = 0;
    double receitaTotal = 0;
    double faturaPagamento = 0;
    double disponivelTotal = 0;
    String limiteFormt = limiteCartao.replaceAll('.', '').replaceAll(',', '.');
    double limite = double.parse(limiteFormt);
    fatura.lancamentos.forEach((item) {
      if (item.eDespesa) {
        String valorFormt = item.valor.replaceAll('.', '').replaceAll(',', '.');
        despesaTotal -= double.parse(valorFormt);
      } else {
        String valorFormt = item.valor.replaceAll('.', '').replaceAll(',', '.');
        receitaTotal += double.parse(valorFormt);
      }
    });
    fatura.pagamentos.forEach((item) {
      String valorFormatado =
          item.valor.replaceAll(".", "").replaceAll(",", ".");
      double valor = double.parse(valorFormatado);
      faturaPagamento += valor;
    });
    double conta = receitaTotal + despesaTotal + moduloNum(faturaPagamento);
    if (conta > 0) {
      disponivelTotal += conta + limite;
    } else {
      disponivelTotal = limite + conta;
    }
    if (disponivelTotal >= valorLanc) {
      return true;
    }
    return false;
  }

  bool possuiSaldoCartao2(Cartao cartaoBase) {
    Cartao cartao =
        repositoryCartao.cartoes.firstWhere((c) => c.nome == cartaoBase.nome);
    String limiteFormt = cartao.limite.replaceAll('.', '').replaceAll(',', '.');
    double limite = double.parse(limiteFormt);

    String valorLancFormt = valor.text.replaceAll('.', '').replaceAll(',', '.');
    double valorLanc = double.parse(valorLancFormt);

    if (limite >= valorLanc) {
      return true;
    }
    return false;
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
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          child: Text(
            'Selecione uma conta ou cartão de crédito',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Suas contas bancárias",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
        for (var i = 0; i < listaContas.length; i++)
          iconesContasCartoes(i, true),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
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
          contaEscolhida = listaContas[i];
          cartaoEscolhido = Cartao(
              nome: "",
              icone: Banco(nome: "", img: ""),
              limite: "",
              diaFechamento: "",
              diaVencimento: "",
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
        if (listaContas[i].banco.img == "Cofrinho" ||
            listaContas[i].banco.img == "Carteira" ||
            listaContas[i].banco.img == "Banco") {
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
        if (listaContas[i].banco.img == "Cofrinho" ||
            listaContas[i].banco.img == "Carteira" ||
            listaContas[i].banco.img == "Banco") {
          return null;
        }
        return AssetImage(listaContas[i].banco.img);
      }
      if (repositoryCartao.cartoes[i].icone.img == "Cartão") {
        return null;
      }
      return AssetImage(repositoryCartao.cartoes[i].icone.img);
    }

    Icon? iconContaCartao() {
      if (eConta) {
        if (listaContas[i].banco.img == "Cofrinho" ||
            listaContas[i].banco.img == "Carteira" ||
            listaContas[i].banco.img == "Banco") {
          if (listaContas[i].banco.img == "Cofrinho") {
            return Icon(
              Icons.savings,
              color: Colors.white,
            );
          }
          if (listaContas[i].banco.img == "Carteira") {
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
        return listaContas[i].nome;
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
