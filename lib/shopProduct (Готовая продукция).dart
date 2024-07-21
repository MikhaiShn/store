import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/productModal.dart';

import 'globals.dart';

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

  @override
  void initState() {
    super.initState();
    getProduct();
    print(modalProduct);
  }

  Future<void> getProduct() async {
    final url =
        'https://baskasha-353162ef52af.herokuapp.com/product/bin/$binClient';
    print('token Product: $token');

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Готовая продукция')),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () {},icon:  Image.asset('assets1/arrowBack.png'),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: modelProduct.length,
                  itemBuilder: (context, index) {
                    final takeFinishedProduct = modelProduct[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 36, 192, 42).withOpacity(
                            0.5), // Пример: красный цвет с 50% прозрачности
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // изменение положения тени
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Модель: ${takeFinishedProduct.modelName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'На складе: ${takeFinishedProduct.productAllQuantity}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10), // Пространство между столбцами
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (takeFinishedProduct
                                      .sizeVariations.isNotEmpty)
                                    Row(
                                      children: [
                                        Text(
                                          'Размеры',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                10), // Пространство между "Размеры" и значением
                                      ],
                                    ),
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
                            if (takeFinishedProduct.sizeVariations.isNotEmpty)
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShopProductDetail(
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
                    );
                  },
                ),
    );
  }
}

class ShopProductDetail extends StatefulWidget {
  ShopProductDetail({super.key, required this.sizeVariationProduct});
  List<SizeVariationProduct> sizeVariationProduct;
  @override
  State<ShopProductDetail> createState() => _ShopProductDetailState();
}

class _ShopProductDetailState extends State<ShopProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.sizeVariationProduct.length,
        itemBuilder: (context, index) {
          final sizeVariation = widget.sizeVariationProduct[index];
          return ExpansionTile(
            title: Text('Размер: ${sizeVariation.size}'),
            children: [
              ListTile(
                title: Text('Цвет: ${sizeVariation.productSizeQuantity}'),
                subtitle:
                    Text('Количество: ${sizeVariation.costProdazhaPrice}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
