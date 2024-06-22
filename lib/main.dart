import 'package:flutter/material.dart';

import 'shopLogIn(страница Авторизации).dart';




void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShopLogIn(),
    );
  }
}
