import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import '../Classes/Livros.dart';

Future<Livros> createLivro(
    String nome, String editora, String author, String ano) async {
  final response = await http.post(
    Uri.parse('http://192.168.100.9:3001/api/livros'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nome': nome,
      'editora': editora,
      'author': author,
      'ano': ano,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Livros.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class CreateLivroPage extends StatefulWidget {
  const CreateLivroPage({super.key});

  @override
  State<CreateLivroPage> createState() => _CreateLivroPageState();
}

class _CreateLivroPageState extends State<CreateLivroPage> {
  Future<Livros>? _futureAlbum;
  @override
  Widget build(BuildContext context) {
    var txtNomeLivro = TextEditingController();
    var txtEditora = TextEditingController();
    var txtAuthor = TextEditingController();
    var txtAno = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Livro'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 40,
          left: 40,
          right: 40,
        ),
        child: Form(
          child: ListView(
            children: <Widget>[
              const Center(
                child: Text(
                  "Livro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txtNomeLivro,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Nome do Livro",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txtAuthor,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Nome do Autor",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txtEditora,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Nome da Editora",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txtAno,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  border: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Ano do Lançamento",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: SizedBox.expand(
                  child: TextButton(
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        wordSpacing: 10,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () {
                      setState(() {
                        _futureAlbum = createLivro(txtNomeLivro.text,
                            txtEditora.text, txtAuthor.text, txtAno.text);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
