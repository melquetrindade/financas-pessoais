import 'package:financas_pessoais/repository/bancos.dart';
import 'package:flutter/material.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({super.key});

  @override
  State<CriarContaPage> createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final RepositoryBanco repositoryBanco = RepositoryBanco();

  void mostarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // importante para permitir altura maior que 50%
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
                controller:
                    scrollController, // importante para scroll funcionar
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
      backgroundColor: Colors.white38,
      body: Center(
        child: IconButton(
            onPressed: () {
              mostarModal(context);
            },
            icon: Icon(Icons.check)),
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
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black54,
                size: 27,
              ),
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
        for(var i = 0; i < repositoryBanco.bancos.length; i++) iconesBancos(i)
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
              backgroundImage: AssetImage("${repositoryBanco.bancos[i].img}")
            )
          ),
          title: Text("${repositoryBanco.bancos[i].nome}", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        )
      ],
    );
  }
}
