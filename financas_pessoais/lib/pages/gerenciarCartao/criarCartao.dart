import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/bancos.dart';
import 'package:financas_pessoais/model/cartao.dart';
import 'package:financas_pessoais/model/conta.dart';
import 'package:financas_pessoais/repository/bancos.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/utils/mySnackBar.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:financas_pessoais/widgets/criarConta/searchIcone.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CriarCartaoPage extends StatefulWidget {
  const CriarCartaoPage({super.key});

  @override
  State<CriarCartaoPage> createState() => _CriarCartaoPageState();
}

class _CriarCartaoPageState extends State<CriarCartaoPage> {
  final RepositoryBanco repositoryBanco = RepositoryBanco();
  late RepositoryContas repositoryContas;
  late List<Conta> listaContas = [];
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final saldo = TextEditingController();
  final diaFecha = TextEditingController();
  final diaVencimento = TextEditingController();
  Banco infoBanco = Banco(nome: "", img: "");
  Conta infoContaPag =
      Conta(nome: "", saldo: "", banco: Banco(nome: "", img: ""));

  void mostrarModal(BuildContext context, int modalTipo) {
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
                  child: modalTipo == 1 ? modalCartao() : modalConta(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    saldo.removeListener(_formatSaldo);
    saldo.dispose();
    super.dispose();
  }

  Widget? iconeCartao() {
    return infoBanco.img == ""
        ? Icon(
            Icons.add,
            color: Colors.white,
          )
        : infoBanco.img == "Cartão"
            ? Icon(
                Icons.credit_card,
                color: Colors.white,
              )
            : null;
  }

  Widget? iconeContaPag() {
    print("Nome da conta de pag: ${infoContaPag.nome}");
    return infoContaPag.banco.img == ""
        ? Icon(
            Icons.add,
            color: Colors.white,
          )
        : infoContaPag.banco.img == "Carteira"
            ? Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              )
            : infoContaPag.banco.img == "Banco"
                ? Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                  )
                : infoContaPag.banco.img == "Cofrinho"
                    ? Icon(
                        Icons.savings,
                        color: Colors.white,
                      )
                    : null;
  }

  Widget? iconeContaPag2(Conta conta) {
    return conta.banco.img == "Carteira"
        ? Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
          )
        : conta.banco.img == "Banco"
            ? Icon(
                Icons.account_balance_rounded,
                color: Colors.white,
              )
            : conta.banco.img == "Cofrinho"
                ? Icon(
                    Icons.savings,
                    color: Colors.white,
                  )
                : null;
  }

  void setarInfoBanco(Banco setBanco) {
    setState(() {
      infoBanco = setBanco;
      Navigator.pop(context);
      Navigator.pop(context);
    });
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
          'Cartão criado com sucesso!',
          context);
      context.read<RepositoryCartao>().notifica();
    } else {
      MySnackBar.mensagem(
          'OK',
          Colors.red,
          Icon(
            Icons.close,
            color: Colors.white,
          ),
          'Você já possui um cartão com este nome!',
          context);
      context.read<RepositoryCartao>().notifica();
    }
  }

  addCartao(Cartao cartao) {
    context.read<RepositoryCartao>().saveCartao(cartao, feedback);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    repositoryContas = context.watch<RepositoryContas>();
    listaContas = repositoryContas.contas;

    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Criar cartão de crédito",
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
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Nome da cartão",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      TextFormField(
                          controller: nome,
                          decoration: InputDecoration(
                            hintText: 'Digite o nome do cartão',
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
                              borderSide:
                                  BorderSide(color: AppColors.azulPrimario),
                            ),
                          ),
                          validator: (value) =>
                              Validador.validatorNomeCartao(value)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Escolha um ícone",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mostrarModal(context, 1);
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
                                  backgroundImage: infoBanco.img == "" ||
                                          infoBanco.img == "Cartão"
                                      ? null
                                      : AssetImage(infoBanco.img),
                                  backgroundColor: infoBanco.img == "" ||
                                          infoBanco.img == "Cartão"
                                      ? AppColors.azulPrimario
                                      : null,
                                  child: iconeCartao(),
                                ),
                              ),
                            ),
                            Text(
                              infoBanco.nome != ""
                                  ? "${infoBanco.nome}"
                                  : "Selecione um ícone",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Limite do cartão",
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
                              borderSide:
                                  BorderSide(color: AppColors.azulPrimario),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validador.validatorSaldoCartao(value)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fechamento',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: diaFecha,
                                    decoration: InputDecoration(
                                      errorMaxLines: 3,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 12),
                                        child: Text(
                                          'Dia',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                        ),
                                      ),
                                      hintText: '24',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.azulPrimario),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      Validador.formatFechaDia(value, diaFecha);
                                    },
                                    validator: (value) =>
                                        Validador.validatorDia(value, true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Vencimento',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: diaVencimento,
                                    decoration: InputDecoration(
                                      errorMaxLines: 3,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 12),
                                        child: Text(
                                          'Dia',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                        ),
                                      ),
                                      hintText: '31',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.azulPrimario),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      Validador.formatFechaDia(
                                          value, diaVencimento);
                                    },
                                    validator: (value) =>
                                        Validador.validatorDia(value, false),
                                  ),
                                ],
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
                            "Conta de pagamento",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mostrarModal(context, 2);
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
                                  backgroundImage: infoContaPag.banco.img ==
                                              "" ||
                                          infoContaPag.banco.img ==
                                              "Carteira" ||
                                          infoContaPag.banco.img == "Banco" ||
                                          infoContaPag.banco.img == "Cofrinho"
                                      ? null
                                      : AssetImage(infoContaPag.banco.img),
                                  backgroundColor: infoContaPag.banco.img ==
                                              "" ||
                                          infoContaPag.banco.img ==
                                              "Carteira" ||
                                          infoContaPag.banco.img == "Banco" ||
                                          infoContaPag.banco.img == "Cofrinho"
                                      ? AppColors.azulPrimario
                                      : null,
                                  child: iconeContaPag(),
                                ),
                              ),
                            ),
                            Text(
                              infoContaPag.nome != ""
                                  ? "${infoContaPag.nome}"
                                  : "Selecione uma conta",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              infoBanco.img != "" &&
                              infoContaPag.banco.img != "") {
                            addCartao(Cartao(
                                nome: nome.text,
                                icone: Banco(
                                    nome: infoBanco.nome, img: infoBanco.img),
                                limite: saldo.text,
                                diaFechamento: diaFecha.text,
                                diaVencimento: diaVencimento.text,
                                conta: Conta(
                                    nome: infoContaPag.nome,
                                    banco: Banco(
                                        nome: infoContaPag.banco.nome,
                                        img: infoContaPag.banco.img),
                                    saldo: infoContaPag.saldo)));
                          } else {
                            MySnackBar.mensagem(
                                'OK',
                                Colors.red,
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                'Erro, preencha os campos corretamente!',
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
                        child: Text("Criar cartão de crédito")),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget modalCartao() {
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
          child: Row(
            children: [
              Spacer(),
              SizedBox(
                width: 45,
              ),
              Text(
                'Selecionar um ícone',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SearchIcone(
                            objtsBancos: repositoryBanco.bancos,
                            funcao: setarInfoBanco));
                  }),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Ícones genéricos",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  infoBanco.img = "Cartão";
                  infoBanco.nome = "Cartão";
                });
                Navigator.pop(context);
              },
              child: ListTile(
                leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.azulPrimario,
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                    )),
                title: Text(
                  "Cartão",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Ícones de instituições bancárias",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        ),
        for (var i = 0; i < repositoryBanco.bancos.length; i++) iconesBancos(i),
      ],
    );
  }

  Widget modalConta() {
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
          child: Row(
            children: [
              Spacer(),
              SizedBox(
                width: 45,
              ),
              Text(
                'Selecionar uma conta',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
        for (var i = 0; i < listaContas.length; i++) iconesContas(i),
      ],
    );
  }

  Widget iconesContas(int i) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              infoContaPag.banco = Banco(
                  nome: listaContas[i].banco.nome,
                  img: listaContas[i].banco.img);
              infoContaPag.nome = "${listaContas[i].nome}";
              //infoContaPag.banco.nome = "${listaContas[i].banco.nome}";
              infoContaPag.saldo = "${listaContas[i].saldo}";
            });
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: listaContas[i].banco.img == "Carteira" ||
                          listaContas[i].banco.img == "Banco" ||
                          listaContas[i].banco.img == "Cofrinho"
                      ? null
                      : AssetImage("${listaContas[i].banco.img}"),
                  backgroundColor: listaContas[i].banco.img == "Carteira" ||
                          listaContas[i].banco.img == "Banco" ||
                          listaContas[i].banco.img == "Cofrinho"
                      ? AppColors.azulPrimario
                      : null,
                  child: listaContas[i].banco.img == "Carteira" ||
                          listaContas[i].banco.img == "Banco" ||
                          listaContas[i].banco.img == "Cofrinho"
                      ? iconeContaPag2(listaContas[i])
                      : null,
                )),
            title: Text(
              "${listaContas[i].nome}",
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

  Widget iconesBancos(int i) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              infoBanco.img = "${repositoryBanco.bancos[i].img}";
              infoBanco.nome = "${repositoryBanco.bancos[i].nome}";
            });
            Navigator.pop(context);
          },
          child: ListTile(
            leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                    radius: 15,
                    backgroundImage:
                        AssetImage("${repositoryBanco.bancos[i].img}"))),
            title: Text(
              "${repositoryBanco.bancos[i].nome}",
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
