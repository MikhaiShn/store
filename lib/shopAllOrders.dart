import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopAllOrders extends StatefulWidget {
  const ShopAllOrders({Key? key}) : super(key: key);

  @override
  State<ShopAllOrders> createState() => _ShopAllOrdersState();
}

class _ShopAllOrdersState extends State<ShopAllOrders> {
  TextEditingController idController = TextEditingController();
  TextEditingController productController = TextEditingController();

  List<Order> orders = []; // Список заказов

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Заказы'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                return buildOrderRow(
                  const Color.fromARGB(255, 209, 209, 209).withOpacity(0.4),
                  context,
                  orders,
                  index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: buildAddButton(
        context,
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  height: 400,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Добавить заказ',
                          style: textH1,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextFormField('id Заказа', idController),
                      buildTextFormField('Продукт', productController),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Order newOrder = Order(
                              id: idController.text,
                              product: productController.text,
                            );
                            setState(() {
                              orders.add(newOrder);
                            });
                            idController.clear();
                            productController.clear();
                            Navigator.pop(context);
                          },
                          child: Text('Добавить'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
