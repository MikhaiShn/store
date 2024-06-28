import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';
import '../globals.dart';

class MaterialDetailPage extends StatefulWidget {
  final String? keys;
  final String? token;
  List<RawMaterial> rawMaterial;
  final Future<void> getMaterial;
  MaterialDetailPage(
      {Key? key,
      required this.keys,
      required this.rawMaterial,
      required this.token,
      required this.getMaterial})
      : super(key: key);

  @override
  _MaterialDetailPageState createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  String groupName = rawGroupNameController.text;
  Future<void> _addRawMaterial() async {
    print('Вызван метод addRawMaterial'); // Проверяем вызов метода
    print('GroupName ${widget.keys}');
    print('addRawMaterial bin $binClient');
    // Создание объекта rawMaterialData из значений контроллеров

    try {
      // Создание POST запроса
      final response = await http.post(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/sklad/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'bin': binClient,
          'groupName': widget.keys,
          'rawMaterialData': {
            "itemRawName": itemRawNameController.text,
            "sellerBIN": selerBINController.text,
            "sellerRawContact": selerRawContactController.text,
            "sellerRawCountry": selerRawCountryController.text,
            "codeitem": codeitemController.text,
            "rawSezon": rawSezonController.text,
            "rawModel": rawModelController.text,
            "rawComment": rawCommentController.text,
            "rawPerson": rawPersonController.text,
            "rawSize": rawSizeController.text,
            "rawColor": rawColorController.text,
            "rawExpiryDate":
                '2026-12-31T00:00:00.000Z', // Убедитесь, что формат даты соответствует ожиданиям сервера
            "rawQuantity": int.parse(rawQuantityController.text),
            "rawUnit": rawUnitController.text,
            "rawPurchaseprice": int.parse(rawPurchasepriceController.text),
            "rawSellingprice": int.parse(rawSellingpriceController.text),
          },
        }),
      );

      print(response.statusCode);

      // Обработка ответа
      if (response.statusCode == 201) {
        print('Материал успешно добавлен');
        final responseBody = jsonDecode(response.body);
        RawMaterial rawMaterial = RawMaterial.fromJson(responseBody);
        rawMaterial.itemRawName = itemRawNameController.text;
        rawMaterial.selerBin = selerBINController.text;
        rawMaterial.selerRawContact = selerRawContactController.text;
        rawMaterial.selerRawCountry = selerRawCountryController.text;
        rawMaterial.codeitem = codeitemController.text;
        rawMaterial.rawSezon = rawSezonController.text;
        rawMaterial.rawModel = rawModelController.text;
        rawMaterial.rawComment = rawCommentController.text;
        rawMaterial.rawPerson = rawPersonController.text;
        rawMaterial.rawSize = rawSizeController.text;
        rawMaterial.rawColor = rawColorController.text;
        rawMaterial.rawQuantity = int.parse(rawQuantityController.text);
        rawMaterial.rawUnit = rawUnitController.text;
        rawMaterial.rawPurchasePrice =
            int.parse(rawPurchasepriceController.text);
        rawMaterial.rawSellingPrice = int.parse(rawSellingpriceController.text);
        widget.getMaterial;
        setState(() {});
      }
    } catch (e) {
      print('Ошибка при отправке запроса: $e');
      // Обработка ошибок при отправке запроса
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.keys!),
        ),
        body: ListView.builder(
          itemCount: widget.rawMaterial.length,
          itemBuilder: (context, index) {
            RawMaterial material = widget.rawMaterial[index];
            return ListTile(
              title: Text(material.itemRawName),
              subtitle: Text('Quantity: ${material.rawQuantity}'),
              // Другие детали материала, которые хотите отобразить
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // 90% of screen width
                        height: MediaQuery.of(context).size.height *
                            0.9, // 60% of screen height
                        padding: EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: Text('Добавить заказ', style: textH1),
                              ),
                              Text(manufacturerIndustryName!),
                              buildTextFormField(
                                  'Название сырья', itemRawNameController),
                              buildTextFormField(
                                  'БИН покупателя', selerBINController),
                              buildTextFormField('Контакты покупателя',
                                  selerRawContactController),
                              buildTextFormField('Страна покупателя',
                                  selerRawCountryController),
                              buildTextFormField('Импорт', importController),
                              buildTextFormField(
                                  'Код сырья', codeitemController),
                              buildTextFormField('Сезон', rawSezonController),
                              buildTextFormField(
                                  'Модель сырья', rawModelController),
                              buildTextFormField(
                                  'Комментарии к сырью', rawCommentController),
                              buildTextFormField(
                                  'Предприятие', rawPersonController),
                              buildTextFormField(
                                  'Размер сырья', rawSizeController),
                              buildTextFormField(
                                  'Цвет сырья', rawColorController),
                              buildTextFormField(
                                  'Срок годности', rawExpiryDateController),
                              buildTextFormField(
                                  'Количество', rawQuantityController),
                              buildTextFormField(
                                  'Единица измерения', rawUnitController),
                              buildTextFormField('Цена на покупку',
                                  rawPurchasepriceController),
                              buildTextFormField(
                                  'Цена на продажу', rawSellingpriceController),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _addRawMaterial();
                                    Navigator.of(context).pop();
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
                          onPressed: () async {
                            await _addRawMaterial();
                            Navigator.of(context)
                                .pop(); // Закрыть диалоговое окно
                            // Добавить материал
                            await widget.getMaterial;
                            print(itemRawNameController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
