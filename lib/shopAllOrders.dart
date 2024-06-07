import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/addZakazModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopLogIn.dart';
class ShopAllOrders extends StatefulWidget {
  
  const ShopAllOrders({Key? key}) : super(key: key);

  @override
  State<ShopAllOrders> createState() => _ShopAllOrdersState();
}

class _ShopAllOrdersState extends State<ShopAllOrders> {
  TextEditingController zakazModelController = TextEditingController();
  TextEditingController zakazSizeController = TextEditingController();
  TextEditingController zakazColorController = TextEditingController();
  TextEditingController zakazQuantityController = TextEditingController();
  TextEditingController zakazUnitController = TextEditingController();
  TextEditingController zakazSellingpriceController = TextEditingController();
  TextEditingController zakazTotalSellingController = TextEditingController();
  TextEditingController zakazCommentController = TextEditingController();
  TextEditingController zakazBinController = TextEditingController();
  TextEditingController zakazManufacturerController = TextEditingController();
  List<Order> orders = []; // Список заказов
  late String _token;
  int total = 50000;

  Future<void> _addZakaz() async {
    try {
      final int? zakazQuantity = int.tryParse(zakazQuantityController.text);
      final int? zakazSellingprice = int.tryParse(zakazSellingpriceController.text);

      if (zakazQuantity == null || zakazSellingprice == null) {
        throw FormatException('Invalid input');
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/zakazy/zakaz'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        "bin": binClient,
        "manufacturerIndustry": manufacturerIndustryName,
        "zakazModel": zakazModelController.text,
        "zakazSize": zakazSizeController.text,
        "zakazColor": zakazColorController.text,
        "zakazComment": zakazCommentController.text,
        "zakazQuantity": zakazQuantity,
        "zakazUnit": zakazUnitController.text,
        "zakazSellingprice": zakazSellingprice,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _token = responseBody['token'] ?? '';
        AddZakaz addZakaz = AddZakaz.fromJson(responseBody);
        addZakaz.zakazModel = zakazModelController.text;
        addZakaz.zakazSize = zakazSizeController.text;
        addZakaz.zakazColor = zakazColorController.text;
        addZakaz.zakazComment = zakazCommentController.text;
        addZakaz.zakazQuantity = zakazQuantity;
        addZakaz.zakazUnit = zakazUnitController.text;
        addZakaz.zakazSellingprice = zakazSellingprice;

        if (_token.isNotEmpty) {
          Map<String, dynamic> payload = Jwt.parseJwt(_token);
          String? _bin = payload['bin'];
          String? _manufacturerIndustry = payload['manufacturerIndustry'];
          addZakaz.bin = _bin ?? '';
          addZakaz.manufacturerIndustry = _manufacturerIndustry ?? '';

          setState(() {
            orders.add(Order(
              zakazModel: addZakaz.zakazModel ?? '',
              zakazSize: addZakaz.zakazSize ?? '',
              zakazColor: addZakaz.zakazColor ?? '',
              zakazQuantity: addZakaz.zakazQuantity ?? 0,
              zakazUnit: addZakaz.zakazUnit ?? '',
              zakazSellingprice: addZakaz.zakazSellingprice ?? 0,
              zakazComment: addZakaz.zakazComment ?? '',
            ));
          });
        }
      } else {
        // Обработка ошибок
        print('Ошибка при добавлении заказа: ${response.statusCode}');
      }
    } catch (e) {
      // Обработка исключений
      print('Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 600,
                  width: 300,
                  child: SingleChildScrollView(
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
                        Text(manufacturerIndustryName),
                        buildTextFormField('Модель', zakazModelController),
                        buildTextFormField('Размер', zakazSizeController),
                        buildTextFormField('Цвет', zakazColorController),
                        buildTextFormField('Количество', zakazQuantityController),
                        buildTextFormField('Единица измерения', zakazUnitController),
                        buildTextFormField('Цена для продажи', zakazSellingpriceController),
                        buildTextFormField('Комментарий', zakazCommentController),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              _addZakaz(); // Добавить заказ
                              Navigator.of(context).pop(); // Закрыть диалог после добавления
                            },
                            child: Text('Добавить'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      //bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}

// Предположим, что у вас есть функция для построения строк заказов
Widget buildOrderRow(Color color, BuildContext context, List<Order> orders, int index) {
  final order = orders[index];
  return Container(
    color: color,
    child: ListTile(
      title: Text(order.zakazModel),
      subtitle: Text('Количество: ${order.zakazQuantity}, Цена: ${order.zakazSellingprice}'),
    ),
  );
}

// Предположим, что у вас есть класс Order
class Order {
  final String zakazModel;
  final String zakazSize;
  final String zakazColor;
  final int zakazQuantity;
  final String zakazUnit;
  final int zakazSellingprice;
  final String zakazComment;

  Order({
    required this.zakazModel,
    required this.zakazSize,
    required this.zakazColor,
    required this.zakazQuantity,
    required this.zakazUnit,
    required this.zakazSellingprice,
    required this.zakazComment,
  });
}

// Предположим, что у вас есть функция для создания TextFormField
Widget buildTextFormField(String labelText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

// Предположим, что у вас есть функция для создания кнопки добавления
Widget buildAddButton(BuildContext context, VoidCallback onPressed) {
  return FloatingActionButton(
    onPressed: onPressed,
    child: Icon(Icons.add),
  );
}
