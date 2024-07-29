import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_apllication_1/calculation/shop_calculation_detail.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals_file/raw_materials_modals.dart';

class MaterialDetailPage extends StatefulWidget {
  final String? token;
  final Future<void> Function() getMaterial;
  final List<RawMaterial> rawMaterial;
  final String groupName;
  final String idIndustry;
  final String idGroup;
  final String checkCalculate;
  final String? calculationID;
  final String modelsID;
  final String? sizeID;
  MaterialDetailPage(
      {Key? key,
      required this.rawMaterial,
      required this.token,
      required this.getMaterial,
      required this.groupName,
      required this.idIndustry,
      required this.idGroup,
      required this.checkCalculate,
      required this.calculationID,
      required this.modelsID,
      required this.sizeID})
      : super(key: key);

  @override
  _MaterialDetailPageState createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  List<RawMaterial> rawMaterial = [];
  String checAppBar = '';
  String title = '';
  int selectedIndex =
      -1; // Индекс выбранного элемента, -1 если ничего не выбрано
  String checkCalculate = '';
  String itemsID = '';
  RawMaterial? material;
  List<String> materialsSelected = [];
  @override
  void initState() {
    // TODO: implement initState
    title = 'Группа: ${widget.groupName}';
    super.initState();
    getMaterialInGroup();
  }

  Future<void> addRawMaterial() async {
    try {
      RawMaterial newItem = RawMaterial(
        itemRawName: itemRawNameController.text,
        sellerBin: sellerRawBINController.text,
        sellerRawContact: selerRawContactController.text,
        sellerRawCountry: selerRawCountryController.text,
        itemImport: rawImportController.text.toLowerCase() == 'true',
        codeitem: rawCodeitemController.text,
        rawSezon: rawSezonController.text,
        rawModel: rawModelController.text,
        rawComment: rawCommentController.text,
        rawPerson: rawPersonController.text,
        rawSize: rawSizeController.text,
        rawColor: rawColorController.text,
        rawQuantity: int.parse(rawQuantityController.text),
        rawUnit: rawUnitController.text,
        rawPurchaseprice: int.parse(rawPurchasepriceController.text),
        rawSellingprice: int.parse(rawSellingpriceController.text),
        rawExpiryDate: '2001-02-01T00:00:00.000Z',
        id: '',
        rawTotalPurchase: 0, // Replace with actual value if needed
        rawTotalSelling: 0, // Replace with actual value if needed
      );

      final response = await http.post(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(newItem.toJson()),
      );

      if (response.statusCode == 201) {
        print('New raw material added successfully');
        clearTextControllers();
        getMaterialInGroup();
      } else {
        print('Failed to add raw material: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding raw material: $error');
    }
  }

  void clearTextControllers() {
    itemRawNameController.clear();
    sellerRawBINController.clear();
    selerRawContactController.clear();
    selerRawCountryController.clear();
    rawImportController.clear();
    rawCodeitemController.clear();
    rawSezonController.clear();
    rawModelController.clear();
    rawCommentController.clear();
    rawPersonController.clear();
    rawSizeController.clear();
    rawColorController.clear();
    rawQuantityController.clear();
    rawUnitController.clear();
    rawPurchasepriceController.clear();
    rawSellingpriceController.clear();
    rawExpiryDateController.clear();
  }

  void updateMaterial() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTextFormField('Item Name', itemRawNameController),
                  buildTextFormField('Seller BIN', sellerRawBINController),
                  buildTextFormField(
                      'Seller Contact', selerRawContactController),
                  buildTextFormField(
                      'Seller Country', selerRawCountryController),
                  buildTextFormField(
                      'Import (true/false)', rawImportController),
                  buildTextFormField('Item Code', rawCodeitemController),
                  buildTextFormField('Raw Season', rawSezonController),
                  buildTextFormField('Raw Model', rawModelController),
                  buildTextFormField('Raw Comment', rawCommentController),
                  buildTextFormField('Raw Person', rawPersonController),
                  buildTextFormField('Raw Size', rawSizeController),
                  buildTextFormField('Raw Color', rawColorController),
                  buildTextFormField('Quantity', rawQuantityController),
                  buildTextFormField('Unit', rawUnitController),
                  buildTextFormField(
                      'Purchase Price', rawPurchasepriceController),
                  buildTextFormField(
                      'Selling Price', rawSellingpriceController),
                  buildTextFormField('Expiry Date', rawExpiryDateController),
                  ElevatedButton(
                    onPressed: () {
                      updateMaterialDetail(material!.id);
                      Navigator.pop(context);
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void navigateToDetailPage(RawMaterial material) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RawMaterialDetailPage(
          materialDetail: material,
          updateMaterialDetail: updateMaterialDetail(material.id),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> deleteRawMaterial(String idMaterial) async {
    final response = await http.delete(Uri.parse(
        'https://baskasha-353162ef52af.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items/$idMaterial'));
    if (response.statusCode == 200) {
      print('Raw material deleted successfully');
    } else {
      print('Failed to delete raw material: ${response.statusCode}');
    }
  }

  Future<void> getMaterialInGroup() async {
    final response = await http.get(Uri.parse(
        'https://baskasha-353162ef52af.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items'));
    if (response.statusCode == 200) {
      print(widget.idGroup);
      final List<dynamic> responseBody = jsonDecode(response.body);
      List<RawMaterial> getListMaterial = responseBody
          .map((data) => RawMaterial.fromJson(data as Map<String, dynamic>))
          .toList();
      setState(() {
        rawMaterial = getListMaterial;
      });
      // Сохраняем JSON-ответ в SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_response', jsonEncode(responseBody));
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  void loadSavedResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedResponse = prefs.getString('saved_response');
    if (savedResponse != null) {
      // Парсим сохранённый JSON-ответ и используем его
      final List<dynamic> responseBody = jsonDecode(savedResponse);
      List<RawMaterial> getListMaterial = responseBody
          .map((data) => RawMaterial.fromJson(data as Map<String, dynamic>))
          .toList();
      setState(() {
        rawMaterial = getListMaterial;
      });
    } else {
      // Если данных нет, делаем GET-запрос
      getMaterialInGroup();
    }
  }

  Future<void> updateMaterialDetail(String idMaterial) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items/$idMaterial'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "itemRawName": itemRawNameController.text,
          "sellerBIN": sellerRawBINController.text,
          "sellerRawContact": sellerTMZContactController.text,
          "sellerRawCountry": selerRawCountryController.text,
          "import": rawImportController.text.toLowerCase() == 'true',
          "codeitem": rawCodeitemController.text,
          "rawSezon": rawSezonController.text,
          "rawModel": rawModelController.text,
          "rawComment": rawCommentController.text,
          "rawPerson": rawPersonController.text,
          "rawSize": rawSizeController.text,
          "rawColor": rawColorController.text,
          "rawExpiryDate": rawExpiryDateController.text,
          "rawQuantity": int.parse(rawQuantityController.text),
          "rawUnit": rawUnitController.text,
          "rawPurchaseprice": double.parse(rawPurchasepriceController.text),
          "rawSellingprice": double.parse(rawSellingpriceController.text),
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Material details updated successfully');
        getMaterialInGroup();
      } else {
        print('Failed to update material details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating material details: $error');
    }
  }

  Future<void> postComponentCalculation(String componentID) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/${widget.calculationID}/models/${widget.modelsID}/sizes/${widget.sizeID}/components'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "componentType": "Сырье",
          "componentID": componentID,
          "quantity": 5
        }),
      );
      print(componentID);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Сырье добавлено в калькуляцию');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopCalculationDetail(
              token: widget.token!,
              calculationID: widget.calculationID!,
              modelsID: widget.modelsID,
              sizeID: widget.sizeID!,
            ),
          ),
        );
      } else {
        print('Failed to add component to calculation: ${response.statusCode}');
        // Handle error appropriately
      }
    } catch (error) {
      print('Error adding component to calculation: $error');
      // Handle error appropriately
    }
  }

  String? selectedMaterials;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text(title)),
          backgroundColor: Colors.grey[200],
          automaticallyImplyLeading:
              checAppBar == 'Иконки' && checkCalculate == 'Калькуляция'
                  ? false
                  : true,
          actions: checAppBar == 'Иконки' && checkCalculate == 'Калькуляция'
              ? [
                  IconButton(
                    onPressed: () {
                      postComponentCalculation(selectedMaterials!);
                    },
                    icon: Icon(Icons.add),
                  ),
                ]
              : checAppBar == 'Иконки'
                  ? [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          updateMaterial();
                        },
                      ),
                      IconButton(
                        onPressed: () async {
                          if (materialsSelected.isNotEmpty) {
                            // Подтверждение удаления
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Удалить материалы?'),
                                  content: Text(
                                      'Вы уверены, что хотите удалить выбранные материалы?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Удалить'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete) {
                              // Удаление выбранных материалов
                              for (String id in materialsSelected) {
                                await deleteRawMaterial(id);
                              }
                              setState(() {
                                // Обновление состояния после удаления
                                rawMaterial.removeWhere((item) => materialsSelected.remove(item.id));
                                materialsSelected.clear();
                                checAppBar = '';
                                checkCalculate = '';
                                title = 'Группа ${widget.groupName}';
                              });
                            }
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            checAppBar = '';
                            checkCalculate = '';
                            title = 'Группа ${widget.groupName}';
                            materialsSelected = [];
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                    ]
                  : [] // Возвращаем пустой список виджетов для `actions`
          ),
      body: ListView.builder(
        itemCount: rawMaterial.length,
        itemBuilder: (context, index) {
          final item = rawMaterial[index];
          final isSelected = materialsSelected.contains(item.id);
          return GestureDetector(
            onLongPress: () {
              setState(() {
                checAppBar = 'Иконки';
                checkCalculate = widget.checkCalculate;
                materialsSelected.add(item.id);
              });

              if (checAppBar == 'Иконки' && checkCalculate == 'Калькуляция') {
                title = 'Выберите сырье';
                selectedMaterials = item.id;
                setState(() {
                  selectedIndex = (selectedIndex == index)
                      ? -1
                      : index; // Выделяем/снимаем выделение
                      print('selectedMaterials $selectedIndex');
                });
              } else if (checAppBar == 'Иконки') {
                title = 'Выберите действие';
              }
            },
            child: Card(
              margin: EdgeInsets.all(10),
              color: isSelected ? Colors.green : Colors.white,
              child: ListTile(
                title: Text(item.itemRawName),
                subtitle: Text('Item Code: ${item.codeitem}'),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    navigateToDetailPage(item);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.checkCalculate == 'Калькуляция'
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildTextFormField(
                                'Item Name', itemRawNameController),
                            buildTextFormField(
                                'Seller BIN', sellerRawBINController),
                            buildTextFormField(
                                'Seller Contact', selerRawContactController),
                            buildTextFormField(
                                'Seller Country', selerRawCountryController),
                            buildTextFormField(
                                'Import (true/false)', rawImportController),
                            buildTextFormField(
                                'Item Code', rawCodeitemController),
                            buildTextFormField(
                                'Raw Season', rawSezonController),
                            buildTextFormField('Raw Model', rawModelController),
                            buildTextFormField(
                                'Raw Comment', rawCommentController),
                            buildTextFormField(
                                'Raw Person', rawPersonController),
                            buildTextFormField('Raw Size', rawSizeController),
                            buildTextFormField('Raw Color', rawColorController),
                            buildTextFormField(
                                'Quantity', rawQuantityController),
                            buildTextFormField('Unit', rawUnitController),
                            buildTextFormField(
                                'Purchase Price', rawPurchasepriceController),
                            buildTextFormField(
                                'Selling Price', rawSellingpriceController),
                            buildTextFormField(
                                'Expiry Date', rawExpiryDateController),
                            ElevatedButton(
                              onPressed: () {
                                addRawMaterial();
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
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

class RawMaterialDetailPage extends StatelessWidget {
  final RawMaterial materialDetail;
  final Future<void> updateMaterialDetail;

  const RawMaterialDetailPage({
    Key? key,
    required this.materialDetail,
    required this.updateMaterialDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали Сырья: ${materialDetail.rawModel ?? 'Не указано'}'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildTextFormField(
                              'Item Name', itemRawNameController),
                          buildTextFormField(
                              'Seller BIN', sellerRawBINController),
                          buildTextFormField(
                              'Seller Contact', selerRawContactController),
                          buildTextFormField(
                              'Seller Country', selerRawCountryController),
                          buildTextFormField(
                              'Import (true/false)', rawImportController),
                          buildTextFormField(
                              'Item Code', rawCodeitemController),
                          buildTextFormField('Raw Season', rawSezonController),
                          buildTextFormField('Raw Model', rawModelController),
                          buildTextFormField(
                              'Raw Comment', rawCommentController),
                          buildTextFormField('Raw Person', rawPersonController),
                          buildTextFormField('Raw Size', rawSizeController),
                          buildTextFormField('Raw Color', rawColorController),
                          buildTextFormField('Quantity', rawQuantityController),
                          buildTextFormField('Unit', rawUnitController),
                          buildTextFormField(
                              'Purchase Price', rawPurchasepriceController),
                          buildTextFormField(
                              'Selling Price', rawSellingpriceController),
                          buildTextFormField(
                              'Expiry Date', rawExpiryDateController),
                          ElevatedButton(
                            onPressed: () {
                              // Вставьте логику для обновления
                              Navigator.pop(context);
                            },
                            child: Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailCard(
                        'Название предмета', materialDetail.itemRawName),
                    buildDetailCard('BIN продавца', materialDetail.sellerBin),
                    buildDetailCard(
                        'Контакт продавца', materialDetail.sellerRawContact),
                    buildDetailCard(
                        'Страна продавца', materialDetail.sellerRawCountry),
                    buildDetailCard('Импорт',
                        materialDetail.itemImport == true ? 'Да' : 'Нет'),
                    buildDetailCard('Код предмета', materialDetail.codeitem),
                    buildDetailCard('Сезон сырья', materialDetail.rawSezon),
                    buildDetailCard('Модель сырья', materialDetail.rawModel),
                    buildDetailCard(
                        'Комментарий к сырью', materialDetail.rawComment),
                    buildDetailCard(
                        'Ответственное лицо', materialDetail.rawPerson),
                    buildDetailCard('Размер сырья', materialDetail.rawSize),
                    buildDetailCard('Цвет сырья', materialDetail.rawColor),
                    buildDetailCard('Количество',
                        materialDetail.rawQuantity?.toString() ?? 'Не указано'),
                    buildDetailCard(
                        'Единица измерения', materialDetail.rawUnit),
                    buildDetailCard(
                        'Закупочная цена',
                        materialDetail.rawPurchaseprice?.toString() ??
                            'Не указано'),
                    buildDetailCard(
                        'Цена продажи',
                        materialDetail.rawSellingprice?.toString() ??
                            'Не указано'),
                    buildDetailCard(
                        'Срок годности', materialDetail.rawExpiryDate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailCard(String title, String? value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value ?? 'Не указано'),
      ),
    );
  }
}
