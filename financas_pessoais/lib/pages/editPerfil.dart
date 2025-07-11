import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/repository/perfil.dart';
import 'package:financas_pessoais/utils/mySnackBar.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditPerfil extends StatefulWidget {
  final String nomeUser;
  const EditPerfil({super.key, required this.nomeUser});

  @override
  State<EditPerfil> createState() => _EditPerfilState();
}

class _EditPerfilState extends State<EditPerfil> {
  late RepositoryPerfil repositoryPerfil;
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  bool loadingUpdate = false;

  @override
  void initState() {
    super.initState();
    nome.text = widget.nomeUser;
  }

  @override
  Widget build(BuildContext context) {
    repositoryPerfil = context.watch<RepositoryPerfil>();
    return Scaffold(
        backgroundColor: AppColors.backgroundClaro,
        appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Editar Perfil",
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
                            "Nome",
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
                            hintText: 'Digite seu nome',
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
                          inputFormatters: [
                            // Esta linha impede a digitação de espaços
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          validator: (value) =>
                              Validador.validatorNomeConta(value)),
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
                            // chama o uploadNome
                            print("tudo ok, chamar o update nome");
                            context
                                .read<RepositoryPerfil>()
                                .updateNome(nome.text);
                            Navigator.pop(context);
                            MySnackBar.mensagem(
                                'OK',
                                Colors.green,
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                'Nome atualizado com sucesso!',
                                context);
                          } else {
                            MySnackBar.mensagem(
                                'OK',
                                Colors.red,
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                'Erro, informe corretamente seu nome!',
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
