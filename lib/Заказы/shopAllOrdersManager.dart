import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/getProductModal.dart';

import '../modals/getZakaz.dart';

class ShopAllOrdersManager extends StatefulWidget {
  const ShopAllOrdersManager({Key? key}) : super(key: key);

  @override
  State<ShopAllOrdersManager> createState() => _ShopAllOrdersManagerState();
}

class _ShopAllOrdersManagerState extends State<ShopAllOrdersManager> {
  late String _token;
  List<GetZakaz> listGetZakaz = [];
  List<GetProduct> getProduct = [];

  @override
  void initState() {
    super.initState();
    getZakaz();
    getProductList();
  }

  void _selectQuantityOption(String value) {
    setState(() {
      zakazModelController.text = value;
      getModal = value;
      int index = modalProduct.indexOf(value);
    });
  }

  List<String> zakazModels = [];
  Future<void> getZakaz() async {
    try {
      final response = await http.get(Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/zakazy/all'));
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

  Map<String, int> productAvailability = {};

  Future<void> getProductList() async {
    final url =
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/all';
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

  void deleteZakaz(String id) {
    setState(() {
      listGetZakaz.removeWhere((zakaz) => zakaz.sId == id);
    });
    // Здесь можно добавить логику для удаления заказа на сервере
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
    );
  }
}

