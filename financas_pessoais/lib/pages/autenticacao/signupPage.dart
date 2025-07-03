import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:financas_pessoais/utils/validador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmeSenha = TextEditingController();
  bool visibilitySenha = false;
  bool visibilityConfSenha = false;
  bool loading = false;

  cadastrar() async {
    setState(() => loading = true);
    try {
      await context
          .read<AuthService>()
          .registrar(nome.text, email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulPrimario,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.blue.shade300, width: 4)),
                    child: Icon(
                      Icons.lock_person_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Crie sua conta",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nome,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    labelText: 'Nome'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    Validador.validatorNome(value),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) =>
                                      Validador.validatorEmail(value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: senha,
                                  decoration: InputDecoration(
                                      suffixIcon: inkWellSenha(),
                                      errorMaxLines: 3,
                                      helperText:
                                          "Deve ter pelo menos 8 caracteres, 1 letra maiúscula e 1 número",
                                      helperMaxLines: 3,
                                      floatingLabelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelText: 'Senha'),
                                  obscureText: visibilitySenha,
                                  validator: (value) =>
                                      Validador.validatorSenha(value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: confirmeSenha,
                                  decoration: InputDecoration(
                                      suffixIcon: inkWellConfSenha(),
                                      errorMaxLines: 3,
                                      floatingLabelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelText: 'Confirme sua senha'),
                                  obscureText: visibilityConfSenha,
                                  validator: (value) =>
                                      Validador.validatorConfirmeSenha(
                                          value, senha.text),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print("tudo ok");
                            cadastrar();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300, // Cor do botão
                          foregroundColor: Colors.white, // Cor do texto/ícone
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (loading)
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Cadastrar",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ],
                        )),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      context.read<AuthService>().controllerPags("sigin");
                    },
                    child: Text(
                      "Já possui uma conta? Faça o login!",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inkWellConfSenha() {
    return InkWell(
      onTap: () {
        print("muda a op");
        setState(() {
          visibilityConfSenha = !visibilityConfSenha;
        });
      },
      child: visibilityConfSenha == true
          ? Icon(Icons.visibility_off, color: AppColors.azulPrimario)
          : Icon(Icons.visibility, color: AppColors.azulPrimario),
    );
  }

  Widget inkWellSenha() {
    return InkWell(
      onTap: () {
        print("muda a op");
        setState(() {
          visibilitySenha = !visibilitySenha;
        });
      },
      child: visibilitySenha == true
          ? Icon(
              Icons.visibility_off,
              color: AppColors.azulPrimario,
            )
          : Icon(
              Icons.visibility,
              color: AppColors.azulPrimario,
            ),
    );
  }
}
