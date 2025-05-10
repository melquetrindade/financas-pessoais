import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/bancos.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:financas_pessoais/widgets/criarConta/searchIcone.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarContaPage extends StatefulWidget {
  final String nomeConta;
  final String imgConta;
  final String saldo;
  const EditarContaPage(
      {super.key,
      required this.nomeConta,
      required this.imgConta,
      required this.saldo});

  @override
  State<EditarContaPage> createState() => _EditarContaPageState();
}

class _EditarContaPageState extends State<EditarContaPage> {
  final RepositoryBanco repositoryBanco = RepositoryBanco();
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final saldo = TextEditingController();
  String imgIcone = "";

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

  @override
  void initState() {
    super.initState();
    nome.text = widget.nomeConta;
    imgIcone = widget.imgConta;
    saldo.text = widget.saldo;
    saldo.addListener(_formatSaldo);
  }

  void _formatSaldo() {
    String text = saldo.text;

    // Remove tudo que não for dígito
    String onlyDigits = text.replaceAll(RegExp(r'[^\d]'), '');

    if (onlyDigits.isEmpty) {
      saldo.value = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    // Interpreta como valor monetário
    double value = double.parse(onlyDigits) / 100;

    // Formata usando intl
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    String newText = formatter.format(value).trim();

    // Mantém a posição do cursor
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

  Widget? iconeConta() {
    return imgIcone == ""
        ? Icon(
            Icons.add,
            color: Colors.white,
          )
        : imgIcone == "Carteira"
            ? Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              )
            : imgIcone == "Banco"
                ? Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                  )
                : imgIcone == "Cofrinho"
                    ? Icon(
                        Icons.savings,
                        color: Colors.white,
                      )
                    : null;
  }

  void setarImgIcone(String icone) {
    setState(() {
      imgIcone = icone;
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Editar conta",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    print("excluir conta");
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
                            "Nome da conta",
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
                            hintText: 'Digite o nome da conta',
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
                          validator: (value) =>
                              Validador.validatorNomeConta(value)),
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
                                  backgroundImage: imgIcone == "" ||
                                          imgIcone == "Carteira" ||
                                          imgIcone == "Banco" ||
                                          imgIcone == "Cofrinho"
                                      ? null
                                      : AssetImage(imgIcone),
                                  backgroundColor: imgIcone == "" ||
                                          imgIcone == "Carteira" ||
                                          imgIcone == "Banco" ||
                                          imgIcone == "Cofrinho"
                                      ? AppColors.azulPrimario
                                      : null,
                                  child: iconeConta(),
                                ),
                              ),
                            ),
                            Text(
                              "Selecione um ícone",
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
                            "Saldo da conta",
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
                          print("Cadastrar");
                          if (formKey.currentState!.validate() &&
                              imgIcone != "") {
                            print("tudo ok");
                            print(
                                "dados da conta=> nome: ${nome.text} - ícone: ${imgIcone} - saldo: ${saldo.text}");
                          } else {
                            if (imgIcone == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erro, selecione um ícone para prosseguir!'),
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
                        child: Text("Salvar alterações")),
                  ),
                ),
              ],
            ),
          ),
        ));
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
                            funcao: setarImgIcone));
                  }),
            ],
          ),
        ),
        /*
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Buscar um ícone',
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
              suffixIcon: IconButton(
                  onPressed: () {
                    print("Pesquisar ícone");
                    showSearch(
                        context: context,
                        delegate:
                            SearchIcone(objtsBancos: repositoryBanco.bancos));
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black54,
                    size: 27,
                  )),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
          ),
        ),*/
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
                  imgIcone = "Carteira";
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
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                    )),
                title: Text(
                  "Carteira",
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
        Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  imgIcone = "Banco";
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
                        Icons.account_balance_rounded,
                        color: Colors.white,
                      ),
                    )),
                title: Text(
                  "Banco",
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
        InkWell(
          onTap: () {
            setState(() {
              imgIcone = "Cofrinho";
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
                    Icons.savings,
                    color: Colors.white,
                  ),
                )),
            title: Text(
              "Cofrinho",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
            ),
          ),
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

  Widget iconesBancos(int i) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              imgIcone = "${repositoryBanco.bancos[i].img}";
            });
            print("${repositoryBanco.bancos[i].nome}");
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
