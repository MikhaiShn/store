import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals_file/product_modals.dart';
import 'package:shop_apllication_1/shop_product/shop_product_detail.dart';
import 'package:shop_apllication_1/shop.dart';

import '../globals.dart';

class ShopProduct extends StatefulWidget {
  const ShopProduct({super.key});

  @override
  State<ShopProduct> createState() => _ShopProductState();
}

class _ShopProductState extends State<ShopProduct> {
  List<FinishedProduct> finishedProduct = [];
  List<ItemModelProduct> modelProduct = [];
  bool isLoading = true;
  String errorMessage = '';
  int selectedIndex = -1;
  String appbarVision = '';
  String title = 'Готовая продукция';
  String companyProductID = '';
  String modelID = '';


  @override
  void initState() {
    super.initState();
    getProduct();
    print(modalProduct);
  }

  Future<void> deleteProductModel(
      String companyProductID, String modelID) async {
    final response = await http.delete(Uri.parse(
        'https://baskasha-353162ef52af.herokuapp.com/product/$companyProductID/models/$modelID'));
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Успешно удалено'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
        getProduct();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Не удалось удалить')));
    }
  }

  Future<void> getProduct() async {
    final url =
        'https://baskasha-353162ef52af.herokuapp.com/product/bin/$binClient';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          finishedProduct = responseBody
              .map((data) => FinishedProduct.fromJson(data))
              .toList();
          modelProduct =
              finishedProduct.expand((product) => product.itemModels).toList();

          print(modelProduct.length);
          isLoading = false;
        });
        print('Successfully fetched products.');
      } else {
        setState(() {
          errorMessage =
              'Ошибка при получении продуктов: ${response.statusCode}';
          isLoading = false;
        });
        print('Ошибка при получении продуктов: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка: $e';
        isLoading = false;
      });
      print('Ошибка: $e');
    }
  }

  Future<void> addProduct() async {
    final response =
        await http.post(Uri.parse(''), headers: {}, body: jsonEncode({}));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        automaticallyImplyLeading: false,
        leading: appbarVision == ''
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Shop(
                                token: token!,
                              )));
                },
                icon: Image.asset('assets1/arrowBack.png'),
              )
            : SizedBox.shrink(), // Скрывает иконку
        actions: appbarVision == "Зажатие"
            ? [
                IconButton(
                    onPressed: () {
                      deleteProductModel(finishedProduct.first.id, modelID);
                    },
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        appbarVision = '';
                        title = 'Готовая продукция';
                        selectedIndex = -1;
                      });
                    },
                    icon: Icon(Icons.close))
              ]
            : [],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: modelProduct.length,
                  itemBuilder: (context, index) {
                    final takeFinishedProduct = modelProduct[index];
                    modelID = takeFinishedProduct.id;
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          appbarVision = 'Зажатие';
                          title = 'Выберите действие';
                          selectedIndex = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 36, 192, 42).withOpacity(
                                0.5), // Пример: красный цвет с 50% прозрачности
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: selectedIndex == -1
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.grey,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // изменение положения тени
                              ),
                            ],
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Модель: ${takeFinishedProduct.modelName} qweqweqxqwee',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'На складе: ${takeFinishedProduct.productAllQuantity}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width: 10), // Пространство между столбцами
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        if (takeFinishedProduct
                                            .sizeVariations.isNotEmpty)
                                          Text(
                                            'Размеры',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // Обрезка текста с добавлением троеточия
                                            maxLines:
                                                1, // Максимальное количество строк
                                          ),
                                        SizedBox(
                                            width:
                                                10), // Пространство между "Размеры" и значением
                                        Text(
                                          'Цена: ${takeFinishedProduct.summaProdazhaPrice}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow
                                                .ellipsis, // Текст с многоточием при необходимости
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (takeFinishedProduct
                                    .sizeVariations.isNotEmpty)
                                  Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ShopProductDetail(
                                              sizeVariationProduct:
                                                  takeFinishedProduct
                                                      .sizeVariations,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.arrow_right_alt),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

