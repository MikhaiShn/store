import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopCategory.dart';
import 'package:shop_apllication_1/shopHome.dart';
import 'package:shop_apllication_1/shopProfile.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  TextStyle textH1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' '),
        backgroundColor: brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints:
                    BoxConstraints.expand(width: double.infinity, height: 100),
                decoration: BoxDecoration(
                    color: brown,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(child: Text('Сумма всего актива', style: textH1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints:
                    BoxConstraints.expand(width: double.infinity, height: 100),
                decoration: BoxDecoration(
                    color:brown,
                    borderRadius: BorderRadius.circular(10.0)),
                child:
                    Center(child: Text('Доход за этот месяц', style: textH1)),
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: BoxConstraints.expand(
                        width: double.infinity, height: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                        color:brown),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color:brown,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                  color:brown,
                ),
                label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(152, 105, 90, 0.65),
                ),
                label: 'Profile')
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ShopHome()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShopCategory()));
            }
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShopProfile()));
            }
          }),
      drawer: Container(
        width: 270,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:brown),
                ),
                Text('Модели'),
                Text('Работы кроц'),
                Text('Полный список сырья'),
                Text('Добавить заказ'),
                Text('Полный список ТМ3')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
