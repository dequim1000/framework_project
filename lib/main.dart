import 'package:flutter/material.dart';
import 'package:framework_project/Screens/CreateLivro.dart';
import 'package:framework_project/Screens/HomePage.dart';
import 'package:provider/provider.dart';

import 'Providers/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Providers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Biblioteca VGA',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: const HomePage(),
        routes: {
          'home': (context) => const HomePage(),
          'criarLivro': (context) => const CreateLivroPage(),
        },
      ),
    );
  }
}
