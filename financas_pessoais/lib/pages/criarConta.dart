import 'package:flutter/material.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({super.key});

  @override
  State<CriarContaPage> createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  void mostarModal(BuildContext context) {
    /*
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ocupar a altura total
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Bordas arredondadas no topo
      ),
      builder: (BuildContext context) {
        return modal();
      },
    );*/
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
                controller: scrollController, // importante para scroll funcionar
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: List.generate(30, (index) => ListTile(
                      title: Text('Item $index'),
                    )),
                  ),
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
      body: Center(
        child: IconButton(
            onPressed: () {
              mostarModal(context);
            },
            icon: Icon(Icons.check)),
      ),
    );
  }

  Widget modal(){
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 50,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black,
              ),
              height: 3,
              width: 150,
            ),
            Row(
              children: [
                Spacer(), // empurra o texto para o centro
                Text(
                  'Selecionar um ícone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(), // empurra o botão pro canto
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)
                ),
              ],
            ),
            Container(
              height: 200,
              width: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            /*
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListTile(
                 title: Center(child: Text("Selecione um ícone")),
                 trailing: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close)
              ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
