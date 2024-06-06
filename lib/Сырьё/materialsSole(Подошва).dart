import 'package:flutter/material.dart';

import '../globals.dart';

class ShopMaterialsSole extends StatefulWidget {
  const ShopMaterialsSole({super.key});

  @override
  State<ShopMaterialsSole> createState() => _ShopMaterialsSoleState();
}

class _ShopMaterialsSoleState extends State<ShopMaterialsSole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подошва'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Возврат на предыдущий экран
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButton: buildAddButton(context, () {}),
    );
  }
}
