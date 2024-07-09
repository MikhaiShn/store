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
  List<ProductModal> finishedProduct = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getProduct();
    print(modalProduct);
  }

  Future<void> getProduct() async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/all';
    print('token Product: $token');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          finishedProduct = responseBody.map((data) => ProductModal.fromJson(data)).toList();
          isLoading = false;
          modalProduct = finishedProduct.map((product) => product.productName!).toList();
        });
        print('Successfully fetched products.');
      } else {
        setState(() {
          errorMessage = 'Ошибка при получении продуктов: ${response.statusCode}';
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

  Future<void> addProduct() async{
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/add';
    final headers = {'Content-Type': 'application/json'};
    final response =await http.post(Uri.parse(url), headers: headers, body: jsonEncode({
    'bin': '',
    'manufacturerIndustry': '',
    'productName': '',
    'productType': '',
    'codeitem': '',
    'productSezon':'',
    'productModel': '',
    'productComment': '',
    'productPerson': '',
    'productSize': '',
    'productColor': '',
    'productQuantity': '',
    'productUnit': '',
    'productSebeStoimost': '',
    'productSellingprice': ''
    }));
    if(response.statusCode == 200) {
      getProduct();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Продукты'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: finishedProduct.length,
                  itemBuilder: (context, index) {
                    final takeProduct = finishedProduct[index];
                    return Container(
                      height: 100,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Количество: ${takeProduct.productQuantity}', style: TextStyle(color: Colors.white)),
                          Text('Наименование: ${takeProduct.productName}', style: TextStyle(color: Colors.white)),
                          Text('Цена: ${takeProduct.productSellingprice}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
