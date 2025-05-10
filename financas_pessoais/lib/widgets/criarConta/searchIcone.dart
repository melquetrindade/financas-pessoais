import 'package:financas_pessoais/model/bancos.dart';
import 'package:flutter/material.dart';

class SearchIcone extends SearchDelegate {
  //passar uma função como argumento que vai setar o icone
  final Function funcao;
  final List<Banco> objtsBancos;

  SearchIcone({required this.objtsBancos, required this.funcao});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        color: Color(0xFF1A2AFF),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color(0xFF1A2AFF),
        filled: true,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    );
  }

  @override
  String get searchFieldLabel => "Instituição financeira...";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchQuery = [];
    for (var item in objtsBancos) {
      if (item.nome.toLowerCase().contains(query.toLowerCase())) {
        //print(query);
        matchQuery.add(item);
      }
    }

    if (matchQuery.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off),
            Text(
              "Sem Resultados para: $query",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                print("${matchQuery[i].nome}");
                funcao(matchQuery[i].img);
              },
              child: ListTile(
                leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("${matchQuery[i].img}"))),
                title: Text(
                  "${matchQuery[i].nome}",
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
        );
      },
      padding: EdgeInsets.all(16),
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var item in objtsBancos) {
      if (item.nome.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                print("${matchQuery[i].nome}");
                funcao(matchQuery[i].img);
              },
              child: ListTile(
                leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("${matchQuery[i].img}"))),
                title: Text(
                  "${matchQuery[i].nome}",
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
        );
      },
      padding: EdgeInsets.all(16),
      itemCount: matchQuery.length,
    );
  }
}
