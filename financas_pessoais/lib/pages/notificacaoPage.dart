import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:financas_pessoais/model/notificacao.dart';
import 'package:financas_pessoais/repository/notificacao.dart';
import 'package:flutter/material.dart';

class NotificacaoPage extends StatefulWidget {
  const NotificacaoPage({super.key});

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  final RepositoryNotificacao repositoryNotificacao = RepositoryNotificacao();
  late List<Notificacao> listNotificacao;

  @override
  Widget build(BuildContext context) {
    listNotificacao = repositoryNotificacao.notificacoes;

    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      appBar: AppBar(
        backgroundColor: AppColors.azulPrimario,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Notificações',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              for(int i = 0; i < listNotificacao.length; i++) cardNotificacao(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardNotificacao(int i) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info_outline, size: 25, color: Colors.black54,),
          title: Text(listNotificacao[i].titulo, style: TextStyle(
            fontSize: 15,
            color: const Color.fromARGB(221, 27, 27, 27),
            fontWeight: FontWeight.w500
          ),),
          subtitle: Text(listNotificacao[i].body, style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w400
          ),),
        ),
        Divider()
      ],
    );
  }
}
