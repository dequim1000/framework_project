import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:framework_project/Classes/Livros.dart';
import 'package:http/http.dart' as http;

Future<Livros> fetchLivros() async {
  final response =
      await http.get(Uri.parse('http://192.168.100.9:3001/api/livros'));

  print(response);
  print(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Livros.fromJson(json.decode(response.body));
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
  late Future<Livros> futureLivros;
  @override
  void initState() {
    super.initState();
    futureLivros = fetchLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Biblioteca'),
      ),
      body: Center(
        child: FutureBuilder<Livros>(
          future: futureLivros,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                tileColor: Colors.white,
                contentPadding: EdgeInsets.all(10),
                dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Row(
                  children: [
                    Text(
                      snapshot.data!.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      snapshot.data!.ano.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      snapshot.data!.editora.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      snapshot.data!.author.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(Icons.more_vert),
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
  }
}
