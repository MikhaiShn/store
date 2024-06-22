import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пример с PopupMenuButton'),
      ),
      body: Center(
        child: PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text('Опция 1'),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text('Опция 2'),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text('Опция 3'),
            ),
          ],
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('Выбрана опция 1');
        break;
      case 1:
        print('Выбрана опция 2');
        break;
      case 2:
        print('Выбрана опция 3');
        break;
    }
  }
}
