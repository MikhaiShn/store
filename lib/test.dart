import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/getProductModal.dart';

class ShopProductManager extends StatefulWidget {
  const ShopProductManager({super.key});

  @override
  State<ShopProductManager> createState() => _ShopProductManagerState();
}

class _ShopProductManagerState extends State<ShopProductManager> {
  List<GetProduct> finishedProduct = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> getProduct() async {
    final url = 'http://10.0.2.2:5000/product/all'; // Убедитесь, что URL правильный
    print('Fetching products from: $url'); // Отладочное сообщение
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          finishedProduct = responseBody.map((data) => GetProduct.fromJson(data)).toList();
          isLoading = false;
        });
        print('Successfully fetched products.'); // Отладочное сообщение
      } else {
        setState(() {
          errorMessage = 'Ошибка при получении продуктов: ${response.statusCode}';
          isLoading = false;
        });
        print('Ошибка при получении продуктов: ${response.statusCode}');
        print('Response body: ${response.body}'); // Отладочное сообщение
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Ошибка: $e';
        isLoading = false;
      });
      print('Ошибка: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'http://10.0.2.2:5000/product/$id';
    var request = http.Request('DELETE', Uri.parse(url));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        setState(() {
          finishedProduct.removeWhere((product) => product.sId == id);
        });
      } else {
        print('Ошибка при удалении продукта: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void showProductDetails(GetProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
            height: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Детали продукта',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Открыть форму редактирования для продукта
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        buildEditableText('Тип', product.productType.toString()),
                        buildEditableText('Наим-е', product.productName.toString()),
                        buildEditableText('Ком-ий', product.productComment.toString()),
                        buildEditableText('Code', product.codeitem.toString()),
                        buildEditableText('Модель', product.productModel.toString()),
                        buildEditableText('Сезон', product.productSezon.toString()),
                        buildEditableText('Предназначение', product.productPerson.toString()),
                        buildEditableText('Цвет', product.productColor.toString()),
                        buildEditableText('Размер', product.productSize.toString()),
                        buildEditableText('Количество', '${product.productQuantity} ${product.productUnit}'),
                        buildEditableText('Цена себестоимость', product.productSebeStoimost.toString()),
                        buildEditableText('Цена всего себ-ти', product.productTotalSebestoimost.toString()),
                        buildEditableText('Цена для продажи', product.productSellingprice.toString()),
                        buildEditableText('Цена всего продажи', product.productTotalSelling.toString()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text('Закрыть', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildEditableText(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(fontSize: 18),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Открыть форму редактирования для конкретного поля
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Готовые продукты'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Открыть форму для добавления нового продукта
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: finishedProduct.length,
                  itemBuilder: (context, index) {
                    final takeProduct = finishedProduct[index];
                    return Dismissible(
                      key: Key(takeProduct.sId!),  // The argument type 'String?' can't be assigned to the parameter type 'String'. dartargument_type_not_assignable GetProduct takeProduct Type: GetProduct
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        deleteProduct(takeProduct.sId!); // The argument type 'String?' can't be assigned to the parameter type 'String'. dartargument_type_not_assignable GetProduct takeProduct Type: GetProduct
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () => showProductDetails(takeProduct),
                        child: Container(
                          height: 58,
                          margin: EdgeInsets.all(4.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Наим-е: ${takeProduct.productName}', style: TextStyle(color: Colors.white)),
                                  Spacer(),
                                  Text('Model: ${takeProduct.productModel}', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Comment: ${takeProduct.productComment}', style: TextStyle(color: Colors.white)),
                                  Spacer(),
                                  Text('К-во: ${takeProduct.productQuantity}', style: TextStyle(color: Colors.white)),
                                  Text(' ${takeProduct.productUnit}', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
               ),
);
}
}
