
import 'package:flutter/material.dart';
import 'link_list.dart';
import 'create_link.dart';
import 'login.dart';
import 'header.dart';  // Importa header.dart

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disney API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LinkList(),
        '/create': (context) => CreateLink(),
        '/login': (context) => Login(),
      },
    );
  }
}
