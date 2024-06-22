import 'package:flutter/material.dart';

import 'package:shop_apllication_1/globals.dart';

class ShopMaterialsLeather extends StatefulWidget {
  const ShopMaterialsLeather({Key? key});

  @override
  State<ShopMaterialsLeather> createState() => _ShopMaterialsLeatherState();
}

class _ShopMaterialsLeatherState extends State<ShopMaterialsLeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кожа'),
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
