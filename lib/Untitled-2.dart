import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/addZakazModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:http/http.dart' as http;
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
  Future <void> _addZakaz()  async{
        final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/zakazy/zakaz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
    "status": "в процессеМ",
    "_id": "6662ad8f518db738bcdbe94c",
    "bin": zakazBinController.text,
    "manufacturerIndustry": zakazManufacturerController.text,
    "zakazID": '100',
    "zakazModel": zakazModelController.text,
    "zakazSize": zakazSizeController.text,
    "zakazColor": zakazColorController.text,
    "zakazComment": zakazCommentController.text,
    "zakazQuantity": int.parse(zakazQuantityController.text),
    "zakazUnit": zakazUnitController.text,
    "zakazSellingprice": int.parse(zakazTotalSellingController.text),
    "zakazTotalSelling": total,
    "__v": 0
      }),
    );
    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body);
      _token = responseBody['token'];
      AddZakaz addZakaz = AddZakaz.fromJson(jsonDecode(response.body));
      addZakaz.zakazModel = zakazModelController.text;
      addZakaz.zakazSize = zakazSizeController.text;
      addZakaz.zakazColor = zakazColorController.text;
      addZakaz.zakazComment = zakazCommentController.text;
      addZakaz.zakazQuantity = int.parse(zakazQuantityController.text);
      addZakaz.zakazUnit = zakazUnitController.text;
      addZakaz.zakazSellingprice = int.parse(zakazTotalSellingController.text);
      
      if(_token != null){
                Map<String, dynamic> payload = Jwt.parseJwt(_token);
                zakazBinController = payload['bin'];
                zakazManufacturerController = payload['manufacturerIndustry'];
                addZakaz.bin = zakazBinController.text;
                addZakaz.manufacturerIndustry = zakazManufacturerController.text;
      }
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
      //bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
