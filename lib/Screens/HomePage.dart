import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:framework_project/Classes/Livros.dart';
import 'package:framework_project/Providers/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<List<Livros>> fetchLivros() async {
  final response =
      await http.get(Uri.parse('https://livros.s1.sandbox.inf.br/api/livros'));

  print(response);
  print(response.body);

  if (response.statusCode == 200) {
    List listaLivros = json.decode(response.body);
    return listaLivros.map((json) => Livros.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Livros>> futureLivros;
  @override
  void initState() {
    super.initState();
    futureLivros = fetchLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(builder: (context, value, child) {
      futureLivros = fetchLivros();
      return Scaffold(
        backgroundColor: Colors.blue.shade400,
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.blue.shade900,
          backgroundColor: Colors.blue.shade600,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'criarLivro');
          },
        ),
        appBar: AppBar(
          title: const Center(
            child: Text('Biblioteca'),
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: futureLivros,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    Livros livros = snapshot.data![index];
                    var idLivro = snapshot.data![index].id;
                    return Container(
                      //color: Colors.blue.shade900,
                      padding: EdgeInsets.all(15),
                      child: ListTile(
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.all(20),
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          children: [
                            Text(
                              livros.nome,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              livros.author.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              livros.editora.toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              livros.ano.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              child: IconButton(
                                onPressed: () async {
                                  await dialog(idLivro, context);
                                  setState(() {
                                    futureLivros = fetchLivros();
                                  });
                                },
                                icon: Icon(Icons.delete, size: 24),
                              ),
                            ),
                          ],
                        ),
                        onLongPress: () async {
                          await dialog(idLivro, context);
                          setState(() {
                            futureLivros = fetchLivros();
                          });
                        },
                      ),
                    );
                  }),
                );
                //Text(snapshot.data!.nome);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
    });
  }
}

Future<void> dialog(int idLivro, context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Excluir Livro?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Você excluirá permanentemente o Livro!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () async {
              Navigator.pushNamed(context, 'home');
            },
          ),
          TextButton(
            child: const Text('Excluir'),
            onPressed: () async {
              try {
                await http.delete(
                  Uri.parse(
                      'https://livros.s1.sandbox.inf.br/api/livros/$idLivro'),
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao Excluir o Livro"),
                    duration: Duration(
                      seconds: 2,
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
