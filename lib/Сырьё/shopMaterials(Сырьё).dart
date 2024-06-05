import 'package:flutter/material.dart';
import '../globals.dart';
import 'materialsLeather(Кожа).dart';
import 'materialsLock(Замок).dart';
import 'materialsSole.dart';
import 'materialsThreads(Нитки).dart';

class ShopMaterials extends StatefulWidget {
  const ShopMaterials({super.key});

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Сырьё'),
      body: Container(
        child: Column(
          children: [
            buildContainerMaterials('Кожа', context, ShopMaterialsLeather()),
            buildContainerMaterials('Шнурок', context, ShopMaterialsLeather()),
            buildContainerMaterials('Подошва', context, ShopMaterialsSole()),
            buildContainerMaterials('Замок', context, ShopMaterialsLock()),
            buildContainerMaterials('Нить', context, ShopMaterialsThreads()),
          ],
        ),
      ),
      floatingActionButton: buildAddButton(context, () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
