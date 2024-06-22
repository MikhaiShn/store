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

  Future<void> addProduct(Map<String, dynamic> newProduct) async {
  final url = '/product/add';
  final body = jsonEncode(newProduct);
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Product successfully added');
      getProduct(); // Обновление списка продуктов после добавления
    } else {
      print('Ошибка при добавлении продукта: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Ошибка: $e');
    }
  }

  Future<void> getProduct() async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/all';
    print('Fetching products from: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          finishedProduct = responseBody.map((data) => GetProduct.fromJson(data)).toList();
          isLoading = false;
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

  Future<void> deleteProduct(String id) async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/$id';
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

  Future<void> updateProductField(String id, String field, String newValue) async {
    final url = 'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/product/$id';
    final body = jsonEncode({field: newValue});
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.put(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Successfully updated $field for product $id');
      } else {
        print('Ошибка при обновлении $field: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void showEditFieldDialog(GetProduct product, String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактировать $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Введите новое значение для $field',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                String newValue = controller.text;
                updateProductField(product.sId!, field, newValue).then((_) {
                  setState(() {
                    switch (field) {
                      case 'productType':
                        product.productType = newValue;
                        break;
                      case 'productName':
                        product.productName = newValue;
                        break;
                      case 'productComment':
                        product.productComment = newValue;
                        break;
                      case 'codeitem':
                        product.codeitem = newValue;
                        break;
                      case 'productModel':
                        product.productModel = newValue;
                        break;
                      case 'productSezon':
                        product.productSezon = newValue;
                        break;
                      case 'productPerson':
                        product.productPerson = newValue;
                        break;
                      case 'productColor':
                        product.productColor = newValue;
                        break;
                      case 'productSize':
                        product.productSize = newValue;
                        break;
                    }
                  });
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
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
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        buildEditableText('Тип', product.productType.toString(), product),
                        buildEditableText('Наим-е', product.productName.toString(), product),
                        buildEditableText('Ком-ий', product.productComment.toString(), product),
                        buildEditableText('Code', product.codeitem.toString(), product),
                        buildEditableText('Модель', product.productModel.toString(), product),
                        buildEditableText('Сезон', product.productSezon.toString(), product),
                        buildEditableText('Предназначение', product.productPerson.toString(), product),
                        buildEditableText('Цвет', product.productColor.toString(), product),
                        buildEditableText('Размер', product.productSize.toString(), product),
                        buildEditableText('Количество', '${product.productQuantity} ${product.productUnit}', product),
                        buildEditableText('Цена себестоимость', product.productSebeStoimost.toString(), product),
                        buildEditableText('Цена всего себ-ти', product.productTotalSebestoimost.toString(), product),
                        buildEditableText('Цена для продажи', product.productSellingprice.toString(), product),
                        buildEditableText('Цена всего продажи', product.productTotalSelling.toString(), product),
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

  void showAddProductDialog() {
  Map<String, dynamic> newProduct = {
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
  };

  //final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Добавить продукт'),
        content: Form(
         // key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Наименование продукта**'),
                  onSaved: (value) => newProduct['productName'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите наименование продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Тип продукта**'),
                  onSaved: (value) => newProduct['productType'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите тип продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Размер продукта**'),
                  onSaved: (value) => newProduct['productSize'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите размер продукта';
                    }
                    return null;
                  },
                ),                
                TextFormField(
                  decoration: InputDecoration(labelText: 'Количество продукта**'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productQuantity'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите количество продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Единица измерения**'),
                  onSaved: (value) => newProduct['productUnit'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите единицу измерения продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Себестоимость продукта'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productSebeStoimost'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите себестоимость продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Модель продукта**'),
                  onSaved: (value) => newProduct['productModel'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите модель продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Цена продажи'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productSellingprice'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите цену продажи продукта';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Коментарий готовому проукту'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productComment'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите коментарий готовому проукту';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Международный код'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['codeitem'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите код продукта на международном рынке';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Сезон'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productSezon'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите к какому сезону сделан продукт';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Мужской'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => newProduct['productPerson'] = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите Мужчине или женищине';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Добавить'),
            onPressed: () {
              //if (formKey.currentState!.validate()) {
               // formKey.currentState!.save();
                addProduct(newProduct).then((_) {
                  Navigator.of(context).pop();
                });
             // }
            },
          ),
        ],
      );
    },
  );
}


  Widget buildEditableText(String label, String value, GetProduct product) {
    bool showEditIcon = false;
    String field = '';

    switch (label) {
      case 'Тип':
        showEditIcon = true;
        field = 'productType';
        break;
      case 'Наим-е':
        showEditIcon = true;
        field = 'productName';
        break;
      case 'Ком-ий':
        showEditIcon = true;
        field = 'productComment';
        break;
      case 'Code':
        showEditIcon = true;
        field = 'codeitem';
        break;
      case 'Модель':
        showEditIcon = true;
        field = 'productModel';
        break;
      case 'Сезон':
        showEditIcon = true;
        field = 'productSezon';
        break;
      case 'Предназначение':
        showEditIcon = true;
        field = 'productPerson';
        break;
      case 'Цвет':
        showEditIcon = true;
        field = 'productColor';
        break;
      case 'Размер':
        showEditIcon = true;
        field = 'productSize';
        break;
      default:
        break;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(fontSize: 18),
          ),
        ),
        if (showEditIcon)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showEditFieldDialog(product, field, value);
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
            onPressed: showAddProductDialog,
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
                      key: Key(takeProduct.sId!),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        deleteProduct(takeProduct.sId!);
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