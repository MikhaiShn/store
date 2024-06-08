import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/addZakazModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopLogIn.dart';
import 'getZakaz.dart';

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
  
  late String _token;
  int total = 50000;
  List<GetZakaz> listGetZakaz = [];

  @override
  void initState() {
    super.initState();
    getZakaz();
  }

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
        }

        // Обновление списка заказов после добавления нового
        getZakaz();
      } else {
        print('Ошибка при добавлении заказа: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> getZakaz() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/zakazy/all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          listGetZakaz = responseBody.map((data) => GetZakaz.fromJson(data)).toList();
        });
      } else {
        print('Ошибка при получении заказов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

Future<void> deleteZakaz(String id) async {
  try {
    final url = 'http://10.0.2.2:5000/zakazy/zakaz/$id';
    print('Deleting zakaz with URL: $url'); // Debug message
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Успешное удаление, обновляем список заказов
      await getZakaz();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заказ успешно удален')),
      );
    } else {
      print('Ошибка при удалении заказа: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debug message
    }
  } catch (e) {
    print('Ошибка: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: listGetZakaz.length,
        itemBuilder: (context, index) {
          final takeListZakaz = listGetZakaz[index];
          return buildOrderRow(
            context,
            takeListZakaz.sId ?? '', // добавляем id
            takeListZakaz.bin ?? '',
            takeListZakaz.manufacturerIndustry ?? '',
            takeListZakaz.zakazID ?? 0,
            takeListZakaz.zakazModel ?? '',
            takeListZakaz.zakazColor ?? '',
            takeListZakaz.zakazQuantity ?? 0,
            takeListZakaz.zakazSellingprice ?? 0,
            deleteZakaz, // передаем функцию удаления
          );
        },
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
                        SizedBox(height: 20),
                        Center(
                          child: Text('Добавить заказ', style: textH1),
                        ),
                        SizedBox(height: 40),
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
                            onPressed: () async {
                              await _addZakaz(); // Добавить заказ
                              Navigator.of(context).pop(); // Закрыть диалог после добавления
                              await getZakaz(); // Обновить список заказов
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
    );
  }
}

Widget buildOrderRow(
  BuildContext context,
  String id,
  String bin,
  String manufacturerName,
  int zakazID,
  String model,
  String colorZakaz,
  int quantity,
  int sellingPrice,
  Function(String) onDelete, // добавляем параметр функции удаления
) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: double.infinity,
              height: 300,
              child: Column(
                children: [
                  Text('БИН Организации: $bin'),
                  Text('Название организации: $manufacturerName'),
                  Text('Номер заказа: $zakazID'),
                  Text('Модель: $model'),
                  Text('Цвет: $colorZakaz'),
                  Text('Количество: $quantity'),
                  Text('Стоимость: $sellingPrice'),
                ],
              ),
            ),
          );
        },
      );
    },
    child: Expanded(
      child: Container(
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Модель: $model'),
                Text('Цвет: $colorZakaz'),
                Text('Количество: $quantity'),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await onDelete(id);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
