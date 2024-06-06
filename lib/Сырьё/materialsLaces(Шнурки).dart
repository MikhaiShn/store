import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopMaterialsLaces extends StatefulWidget {
  const ShopMaterialsLaces({super.key});

  @override
  State<ShopMaterialsLaces> createState() => _ShopMaterialsLacesState();
}

class _ShopMaterialsLacesState extends State<ShopMaterialsLaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шнурки'),
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
