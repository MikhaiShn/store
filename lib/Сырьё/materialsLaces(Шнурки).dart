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
      appBar: appbarTitle('Шнурки'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
