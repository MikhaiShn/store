import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/tmzModal.dart';

import 'package:shop_apllication_1/globals.dart';

class TmzDetail extends StatefulWidget {
  final String? groupName;
  final String? token;
  final List<Item> material;
  final String? materialId;
  final String? groupId;
  const TmzDetail({
    Key? key,
    required this.token,
    required this.material,
    required this.groupName,
    required this.groupId,
    required this.materialId,
  }) : super(key: key);

  @override
  State<TmzDetail> createState() => _TmzDetailState();
}

class _TmzDetailState extends State<TmzDetail> {
  List<TmzManufacturer> tmzManufacturerClient = [];
  bool _isLoading = false; // Флаг для отслеживания загрузки данных
  List<TMZMaterial> groupsTMZ = [];
  List<Item> tmzMaterial = [];

 @override
  void initState() {
    super.initState();
    getMaterialInTMZ();
  }


  Future<void> updateMaterialDetail(String idMaterial) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items/$idMaterial'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "itemTmzName": itemTmzNameController.text,
          "sellerBin": sellerTMZBINController.text,
          "sellerTmzContact": sellerTMZContactController.text,
          "sellerTmzCountry": sellerTMZCountryController.text,
          "itemImport": tmzImportController.text.toLowerCase() == 'true',
          "codeitem": tmzCodeItemController.text,
          "tmzSezon": tmzSezonController.text,
          "tmzModel": tmzModelController.text,
          "tmzComment": tmzCommentController.text,
          "tmzPerson": tmzPersonController.text,
          "tmzSize": tmzSizeController.text,
          "tmzColor": tmzColorController.text,
          "tmzQuantity": int.parse(tmzQuantityController.text),
          "tmzUnit": tmzUnitController.text,
          "tmzPurchaseprice": int.parse(tmzPurchasepriceController.text),
          "tmzSellingprice": int.parse(tmzSellingpriceController.text),
          "tmzExpiryDate": '2001-02-01T00:00:00.000Z',
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Material details updated successfully');
        getMaterialInTMZ();
      } else {
        print('Failed to update material details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating material details: $error');
    }
  }

  Future<void> deleteTMZbyID(String idMaterial) async {
    final response = await http.delete(Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items/$idMaterial'));
    if (response.statusCode == 200) {
      print('Raw material deleted successfully');
    } else {
      print('Failed to delete raw material: ${response.statusCode}');
    }
  }

  Future<void> addTMZ() async {
    try {
      Item newItem = Item(
        itemTmzName: itemTmzNameController.text,
        sellerBin: sellerTMZBINController.text,
        sellerTmzContact: sellerTMZContactController.text,
        sellerTmzCountry: sellerTMZCountryController.text,
        itemImport: tmzImportController.text.toLowerCase() == 'true',
        codeitem: tmzCodeItemController.text,
        tmzSezon: tmzSezonController.text,
        tmzModel: tmzModelController.text,
        tmzComment: tmzCommentController.text,
        tmzPerson: tmzPersonController.text,
        tmzSize: tmzSizeController.text,
        tmzColor: tmzColorController.text,
        tmzQuantity: int.parse(tmzQuantityController.text),
        tmzUnit: tmzUnitController.text,
        tmzPurchaseprice: int.parse(tmzPurchasepriceController.text),
        tmzSellingprice: int.parse(tmzSellingpriceController.text),
        tmzExpiryDate: '2001-02-01T00:00:00.000Z',
        id: '',
        tmzTotalPurchase: 0, // Replace with actual value if needed
        tmzTotalSelling: 0, // Replace with actual value if needed
      );
      final response = await http.post(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(newItem.toJson()),
      );

      if (response.statusCode == 201) {
        print('New raw material added successfully');
        setState(() {
          widget.material.add(newItem); // Добавляем новый элемент в список
        });
      } else {
        print('Failed to add raw material: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding raw material: $error');
    }
  }

Future<void> getMaterialInTMZ() async {
  final response = await http.get(Uri.parse(
      'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items'));
  if (response.statusCode == 200) {
    print('ТМЗ успешно получены в группе');
    print('${widget.materialId}, ${widget.groupId}');
    final List<dynamic> responseBody = jsonDecode(response.body);
    print('Response Body: $responseBody');
    List<Item> getListMaterial = responseBody
        .map((data) => Item.fromJson(data as Map<String, dynamic>))
        .toList();
    setState(() {
      tmzMaterial = getListMaterial;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName!),
      ),
      body: RefreshIndicator(
        onRefresh: getMaterialInTMZ, // Вызываем getTMZ при тяжении вниз
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Отображаем индикатор загрузки, пока идет запрос
            : ListView.builder(
                itemCount: widget.material.length,
                itemBuilder: (context, index) {
                  Item materialTmz = tmzMaterial[index];
                  return Dismissible(
                      key: Key(materialTmz.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Удаляем элемент из списка и вызываем setState для обновления состояния
                        setState(() {
                          widget.material.removeAt(index);
                        });
                        deleteTMZbyID(
                            materialTmz.id); // Удаление элемента по его tmzId
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(materialTmz.tmzModel),
                          subtitle: Text('Item code: ${materialTmz.codeitem}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                buildTextFormField(
                                                    'Название ТМЗ',
                                                    itemTmzNameController),
                                                buildTextFormField(
                                                    'БИН продавца',
                                                    sellerTMZBINController),
                                                buildTextFormField(
                                                    'Контакт продавца',
                                                    sellerTMZContactController),
                                                buildTextFormField(
                                                    'Страна продавца',
                                                    sellerTMZCountryController),
                                                buildTextFormField('Код товара',
                                                    tmzCodeItemController),
                                                buildTextFormField('Сезон ТМЗ',
                                                    tmzSezonController),
                                                buildTextFormField('Модель ТМЗ',
                                                    tmzModelController),
                                                buildTextFormField(
                                                    'Комментарий к ТМЗ',
                                                    tmzCommentController),
                                                buildTextFormField(
                                                    'К какому полу предназначено',
                                                    tmzPersonController),
                                                buildTextFormField('Размер ТМЗ',
                                                    tmzSizeController),
                                                buildTextFormField('Цвет ТМЗ',
                                                    tmzColorController),
                                                buildTextFormField(
                                                    'Количество ТМЗ',
                                                    tmzQuantityController),
                                                buildTextFormField(
                                                    'Единица измерения ТМЗ',
                                                    tmzUnitController),
                                                buildTextFormField(
                                                    'Цена на покупку',
                                                    tmzPurchasepriceController),
                                                buildTextFormField(
                                                    'Цена на продажу',
                                                    tmzSellingpriceController),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    updateMaterialDetail(materialTmz.id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Update'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          TMZMaterialDetailPage(
                                              material: materialTmz),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(-1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
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
                          1, // 90% of screen width
                      height: MediaQuery.of(context).size.height *
                          1, // 60% of screen height
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
                                'Название ТМЗ', itemTmzNameController),
                            buildTextFormField(
                                'БИН продавца', sellerTMZBINController),
                            buildTextFormField(
                                'Контакт продавца', sellerTMZContactController),
                            buildTextFormField(
                                'Страна продавца', sellerTMZCountryController),
                            buildTextFormField(
                                'Код товара', tmzCodeItemController),
                            buildTextFormField('Сезон ТМЗ', tmzSezonController),
                            buildTextFormField(
                                'Модель ТМЗ', tmzModelController),
                            buildTextFormField(
                                'Комментарий к ТМЗ', tmzCommentController),
                            buildTextFormField('К какому полу предназначено',
                                tmzPersonController),
                            buildTextFormField('Размер ТМЗ', tmzSizeController),
                            buildTextFormField('Цвет ТМЗ', tmzColorController),
                            buildTextFormField(
                                'Количество ТМЗ', tmzQuantityController),
                            buildTextFormField(
                                'Единица измерения ТМЗ', tmzUnitController),
                            buildTextFormField(
                                'Цена на покупку', tmzPurchasepriceController),
                            buildTextFormField(
                                'Цена на продажу', tmzSellingpriceController),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await addTMZ();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Добавить тмз'),
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
                          Navigator.of(context)
                              .pop(); // Закрыть диалоговое окно
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
      ),
    );
  }
}

class TMZMaterialDetailPage extends StatelessWidget {
  final Item material;

  const TMZMaterialDetailPage({Key? key, required this.material})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали Сырья: ${material.tmzModel}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailCard('Название предмета', material.itemTmzName),
              buildDetailCard('BIN продавца', material.sellerBin),
              buildDetailCard('Контакт продавца', material.sellerTmzContact),
              buildDetailCard('Страна продавца', material.sellerTmzCountry),
              buildDetailCard('Импорт', material.itemImport ? 'Да' : 'Нет'),
              buildDetailCard('Код предмета', material.codeitem),
              buildDetailCard('Сезон сырья', material.tmzSezon),
              buildDetailCard('Модель сырья', material.tmzModel),
              buildDetailCard('Комментарий к сырью', material.tmzComment),
              buildDetailCard('Ответственное лицо', material.tmzPerson),
              buildDetailCard('Размер сырья', material.tmzSize),
              buildDetailCard('Цвет сырья', material.tmzColor),
              buildDetailCard('Количество', material.tmzQuantity.toString()),
              buildDetailCard('Единица измерения', material.tmzUnit),
              buildDetailCard(
                  'Закупочная цена', material.tmzPurchaseprice.toString()),
              buildDetailCard(
                  'Цена продажи', material.tmzSellingprice.toString()),
                  buildDetailCard('id ', material.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
