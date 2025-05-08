import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/bancos.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({super.key});

  @override
  State<CriarContaPage> createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final RepositoryBanco repositoryBanco = RepositoryBanco();
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final saldo = TextEditingController();

  void mostarModal(BuildContext context) {
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Criar conta",
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
                        validator: (value) => Validador.validatorNomeConta(value)
                      ),
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SizedBox(
                              width: 37,
                              height: 37,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.azulPrimario,
                                  child: InkWell(
                                      onTap: () {
                                        mostarModal(context);
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ))),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
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
                        validator: (value) => Validador.validatorSaldoConta(value)
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
                          print("Cadastrar");
                          if (formKey.currentState!.validate()) {
                            print("tudo ok");
                          } else {
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
                        child: Text("Criar Conta")),
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
              ), // empurra o texto para o centro
              Text(
                'Selecionar um ícone',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              Spacer(), // empurra o botão pro canto
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
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
            ListTile(
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
                "Cearteira",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w700),
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
            ListTile(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            )
          ],
        ),
        ListTile(
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
        ListTile(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        )
      ],
    );
  }
}
