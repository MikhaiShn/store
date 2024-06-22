import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/getProductModal.dart';

import 'globals.dart';

class ShopProduct extends StatefulWidget {
  const ShopProduct({super.key});

  @override
  State<ShopProduct> createState() => _ShopProductState();
}

class _ShopProductState extends State<ShopProduct> {
  List<GetProduct> finishedProduct = [];
  bool isLoading = true;
  String errorMessage = '';

    @override
  void initState() {
    super.initState();
    getProduct();
    print(modalProduct);
  }


  Future<void> getProduct() async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/all'; // Убедитесь, что URL правильный
    print('Fetching products from: $url'); // Отладочное сообщение
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          finishedProduct = responseBody.map((data) => GetProduct.fromJson(data)).toList();
          isLoading = false;
          modalProduct = finishedProduct.map((product) => product.productName!).toList();
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
    
  // Future<List<Map<String, dynamic>>> getProduct_() async{
  //   var request = await http.Request('GET', Uri.parse('http://10.0.2.2:5000/product/all'));
  //   final response = await request.send();
  //   if(response.statusCode == 200){
  //             String responseBody = await response.stream.bytesToString();
  //       List<dynamic> productsList = jsonDecode(responseBody);
  //       return productsList.cast<Map<String, dynamic>>();
  //   } else {
  //       throw Exception('Ошибка при получении продуктов: ${response.reasonPhrase}');
  //     }
  //   } 
  // }


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
                          // Добавьте другие поля по мере необходимости
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}