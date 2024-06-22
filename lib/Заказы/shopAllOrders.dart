import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/modals/addZakazModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/getProductModal.dart';

import '../modals/getZakaz.dart';

class ShopAllOrders extends StatefulWidget {
   final String token;

  const ShopAllOrders({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopAllOrders> createState() => _ShopAllOrdersState();
}

class _ShopAllOrdersState extends State<ShopAllOrders> {
  late String _token;
  List<GetZakaz> listGetZakaz = [];
  List<GetProduct> getProduct = [];

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    getZakaz();
    getProductList();
  }
  void clearTextFields() {
  zakazModelController.clear();
  zakazSizeController.clear();
  zakazColorController.clear();
  zakazQuantityController.clear();
  zakazUnitController.clear();
  zakazSellingpriceController.clear();
  zakazCommentController.clear();
}
  void _selectQuantityOption(String value) {
    setState(() {
      zakazModelController.text = value;
      getModal = value;
      int index = modalProduct.indexOf(value);
    });
  }

  Future<void> _addZakaz() async {
    try {
      final int? zakazQuantity = int.tryParse(zakazQuantityController.text);
      final int? zakazSellingprice =
          int.tryParse(zakazSellingpriceController.text);

      if (zakazQuantity == null || zakazSellingprice == null) {
        throw FormatException('Invalid input');
      }

      final response = await http.post(
        Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/zakazy/zakaz'),
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

  List<String> zakazModels = [];
  Future<void> getZakaz() async {
    try {
      final response =
          await http.get(Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/zakazy/all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        List<GetZakaz> fetchedZakaz =
            responseBody.map((data) => GetZakaz.fromJson(data)).toList();
        setState(() {
          listGetZakaz = fetchedZakaz;
        });
        // Извлекаем только модели из заказов
        zakazModels =
            fetchedZakaz.map((zakaz) => zakaz.zakazModel ?? '').toList();

        print(zakazModels);
        print(listGetZakaz);
      } else {
        print('Ошибка при получении заказов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> deleteZakaz(String id) async {
    var request =
        http.Request('DELETE', Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/zakazy/$id'));
    final response = await request.send();
    if (response.statusCode == 200) {
      getZakaz();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заказ успешно удален')),
      );
    }
  }

  Map<String, int> productAvailability = {};

  Future<void> getProductList() async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/all';
    print('Fetching products from: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);

      setState(() {
        getProduct =
            responseBody.map((data) => GetProduct.fromJson(data)).toList();
        modalProduct =
            getProduct.map((product) => product.productName!).toList();
        quantityProduct =
            getProduct.map((product) => product.productQuantity).toList();
        int index = modalProduct.indexOf(getModal);
        productAvailability = {
          for (var product in getProduct)
            product.productName!: product.productQuantity!
        };
      });
      print('Successfully fetched products.');
    }
  }





  Future<bool?> _confirmDismiss(BuildContext context, int index, GetZakaz zakaz) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтверждение удаления'),
          content: Text('Вы точно хотите удалить заказ ${zakaz.zakazModel}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Нет'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Да'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      deleteZakaz(zakaz.sId ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заказ ${zakaz.zakazModel} удален')),
      );
    } else {
      setState(() {
        // Перестраиваем виджет для отмены удаления
      });
    }
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Заказы',
          style: textH1,
        )),
      ),
      body: ListView.builder(
        itemCount: listGetZakaz.length,
        itemBuilder: (context, index) {
          final takeListZakaz = listGetZakaz[index];
          return Dismissible(
            key: Key(takeListZakaz.sId!),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => _confirmDismiss(context, index, takeListZakaz),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: buildOrderRow(
              context,
              takeListZakaz.sId ?? '',
              binClient ?? '',
              manufacturerIndustryName ?? '',
              takeListZakaz.zakazID ?? 0,
              takeListZakaz.zakazModel ?? '',
              takeListZakaz.zakazSize ?? ' ',
              takeListZakaz.zakazColor ?? '',
              takeListZakaz.zakazSellingprice ?? 0,
              takeListZakaz.zakazQuantity ?? 0,
              productAvailability[takeListZakaz.zakazModel] ?? 0,
              (id) => deleteZakaz(id),
            ),
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
                child: Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // 90% of screen width
                    height: MediaQuery.of(context).size.height *
                        0.65, // 60% of screen height
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: Text('Добавить заказ', style: textH1),
                          ),
                          Text(manufacturerIndustryName),
                          buildQuantityField(context, zakazModelController,
                              _selectQuantityOption, modalProduct),
                          buildTextFormField('Размер', zakazSizeController),
                          buildTextFormField('Цвет', zakazColorController),
                          buildTextFormField(
                              'Количеств', zakazQuantityController),
                          buildTextFormField(
                              'Единица измерения', zakazUnitController),
                          buildTextFormField(
                              'Цена для продажи', zakazSellingpriceController),
                          buildTextFormField(
                              'Комментарий', zakazCommentController),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _addZakaz(); // Добавить заказ
                                Navigator.of(context)
                                    .pop(); // Закрыть диалог после добавления
                                await getZakaz(); // Обновить список заказов
                              },
                              child: Text('Добавить'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                            Positioned(
            right: 0.0,
            top: 0.0,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
                clearTextFields();
              },
            ),
          ),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
