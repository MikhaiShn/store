import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopMaterialsThreads extends StatefulWidget {
  const ShopMaterialsThreads({super.key});

  @override
  State<ShopMaterialsThreads> createState() => _ShopMaterialsThreadsState();
}

class _ShopMaterialsThreadsState extends State<ShopMaterialsThreads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Нитки'),
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
