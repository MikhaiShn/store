import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals_file/tmz_modals.dart';

import 'package:shop_apllication_1/globals.dart';

import '../calculation/shop_calculation_detail.dart';

class TmzDetail extends StatefulWidget {
  final String? groupName;
  final String? token;
  final List<Item> material;
  final String? materialId;
  final String? groupId;

  final String checkCalculate;
  final String calculationID;
  final String modelsID;
  final String sizeId;

  const TmzDetail({
    Key? key,
    required this.token,
    required this.material,
    required this.groupName,
    required this.groupId,
    required this.materialId,
    required this.checkCalculate,
    required this.calculationID,
    required this.modelsID,
    required this.sizeId,
  }) : super(key: key);

  @override
  State<TmzDetail> createState() => _TmzDetailState();
}

class _TmzDetailState extends State<TmzDetail> {
  List<TmzManufacturer> tmzManufacturerClient = [];
  bool _isLoading = false; // Флаг для отслеживания загрузки данных
  List<TMZMaterial> groupsTMZ = [];
  List<Item> tmzMaterial = [];
  String? checkAppBar = '';
  @override
  void initState() {
    super.initState();
    getMaterialInTMZ();
  }

  Future<void> updateMaterialDetail(String idMaterial) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items/$idMaterial'),
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
        'https://baskasha-353162ef52af.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items/$idMaterial'));
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
            'https://baskasha-353162ef52af.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items'),
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
        'https://baskasha-353162ef52af.herokuapp.com/tmz/${widget.materialId}/groups/${widget.groupId}/items'));
    if (response.statusCode == 200) {
      print('ТМЗ успешно получены в группе');
      final List<dynamic> responseBody = jsonDecode(response.body);
      List<Item> getListMaterial = responseBody
          .map((data) => Item.fromJson(data as Map<String, dynamic>))
          .toList();
      setState(() {
        tmzMaterial = getListMaterial;
      });
    }
  }

  Future<void> postComponentCalculation(String componentID) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/${widget.calculationID}/models/${widget.modelsID}/sizes/${widget.sizeId}/components'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "componentType": "ТМЗ",
          "componentID": componentID,
          "quantity": 0
        }),
      );
      print('Response status code: ${response.statusCode}');
      print('Список idшек: $componentID ');
      print(
          'https://baskasha-353162ef52af.herokuapp.com/calculation/${widget.calculationID}/models/${widget.modelsID}/sizes/${widget.sizeId}/components');
      if (response.statusCode == 200) {
        print('Сырье добавлено в калькуляцию');
      } else {
        print('Failed to add component to calculation: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding component to calculation: $error');
    }
  }

  void iconEdit(String item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextFormField('Название ТМЗ', itemTmzNameController),
                  buildTextFormField('БИН продавца', sellerTMZBINController),
                  buildTextFormField(
                      'Контакт продавца', sellerTMZContactController),
                  buildTextFormField(
                      'Страна продавца', sellerTMZCountryController),
                  buildTextFormField('Код товара', tmzCodeItemController),
                  buildTextFormField('Сезон ТМЗ', tmzSezonController),
                  buildTextFormField('Модель ТМЗ', tmzModelController),
                  buildTextFormField('Комментарий к ТМЗ', tmzCommentController),
                  buildTextFormField(
                      'К какому полу предназначено', tmzPersonController),
                  buildTextFormField('Размер ТМЗ', tmzSizeController),
                  buildTextFormField('Цвет ТМЗ', tmzColorController),
                  buildTextFormField('Количество ТМЗ', tmzQuantityController),
                  buildTextFormField(
                      'Единица измерения ТМЗ', tmzUnitController),
                  buildTextFormField(
                      'Цена на покупку', tmzPurchasepriceController),
                  buildTextFormField(
                      'Цена на продажу', tmzSellingpriceController),
                  SizedBox(height: 20), // Space before the button
                  ElevatedButton(
                    onPressed: () {
                      updateMaterialDetail(selectedItem);

                      Navigator.pop(context);
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, Item materialTmz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Позволяет задать высоту
      backgroundColor: Colors.transparent, // Убирает фон
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            width: double.infinity, // Ширина занимает всю доступную ширину
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                SizedBox(height: 16), // Отступ после заголовка
                Text(
                  materialTmz.itemTmzName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16), // Отступ перед информацией
                _buildInfoRow(Icons.code, 'Item code: ${materialTmz.codeitem}'),
                _buildInfoRow(
                    Icons.person, 'Seller: ${materialTmz.sellerTmzContact}'),
                _buildInfoRow(
                    Icons.flag, 'Country: ${materialTmz.sellerTmzCountry}'),
                _buildInfoRow(
                    Icons.color_lens, 'Color: ${materialTmz.tmzColor}'),
                SizedBox(height: 24), // Отступ перед кнопкой
              ],
            ),
          ),
        );
      },
    );
  }

// Метод для построения строки с иконкой и текстом
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  int selectedIndex = -1;
// Метод для создания заголовка с крестиком для закрытия
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey[800]),
          onPressed: () {
            Navigator.of(context).pop(); // Закрыть BottomSheet
          },
        ),
      ],
    );
  }

  String selectedItem = '';
  List<String> tmzSelected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            checkAppBar == 'Иконки' ? 'Выберите действие' : widget.groupName!),
        backgroundColor:
            checkAppBar == 'Иконки' ? Colors.grey[200] : Colors.white,
        actions: checkAppBar == 'Иконки' &&
                widget.checkCalculate == 'Калькуляция'
            ? [
                IconButton(
                  onPressed: () async {
                    if (tmzSelected.isNotEmpty) {
                      bool confirmAdd = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0)),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Добавить материалы',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Вы выбрали: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            'Отмена',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.greenAccent,
                                          ),
                                          child: Text('Добавить'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ) ??
                          false;

                      if (confirmAdd) {
                        List<Future<void>> futures = [];
                        for (String id in tmzSelected) {
                          print(
                              'Adding component with ID: $id'); // Отладочная информация
                          futures.add(postComponentCalculation(id));
                          await Future.delayed(Duration(milliseconds: 500));
                        }
                        await Future.wait(futures);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopCalculationDetail(
                              token: widget.token!,
                              calculationID: widget.calculationID,
                              modelsID: widget.modelsID,
                              sizeID: widget.sizeId,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.add),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        checkAppBar = '';

                        tmzSelected = [];
                      });
                    },
                    icon: Icon(Icons.close)),
              ]
            : checkAppBar == 'Иконки'
                ? [
                    IconButton(
                      onPressed: () {
                        iconEdit(
                            selectedItem); // Вызываем метод для отображения диалога
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (tmzSelected.isNotEmpty) {
                            bool confirmDelete = await showModalBottomSheet<
                                    bool>(
                                  context: context,
                                  isScrollControlled:
                                      true, // Позволяет задать высоту для содержимого
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Удалить материалы?',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Вы уверены, что хотите удалить выбранные материалы?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text(
                                                  'Отмена',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors
                                                      .red, // Цвет текста кнопки
                                                ),
                                                child: Text('Удалить'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ) ??
                                false;
                            if (confirmDelete) {
                              for (String id in tmzSelected) {
                                deleteTMZbyID(id);
                              }
                              setState(() {
                                tmzMaterial.removeWhere(
                                    (item) => tmzSelected.remove(item.id));
                                tmzSelected.clear();
                                checkAppBar = '';
                              });
                            }
                          }
                        },
                        icon: Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            checkAppBar = '';
                            tmzSelected = [];
                          });
                        },
                        icon: Icon(Icons.close)),
                  ]
                : [],
      ),
      body: RefreshIndicator(
          onRefresh: getMaterialInTMZ,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: tmzMaterial.length,
                  itemBuilder: (context, index) {
                    Item materialTmz = tmzMaterial[index];
                    final isSelected = tmzSelected.contains(materialTmz.id);
                    return widget.checkCalculate == 'Калькуляция'
                        ? InkWell(
                            onTap: () => _showBottomSheet(context, materialTmz),
                            onLongPress: () {
                              setState(() {
                                selectedIndex = (selectedIndex == index)
                                    ? -1
                                    : index; // Переключаем состояние
                                checkAppBar = 'Иконки';
                                selectedItem = materialTmz.id;
                                tmzSelected.add(materialTmz.id);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Card(
                                elevation: 8,
                                color: isSelected
                                    ? Colors.greenAccent
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              materialTmz.itemTmzName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Item code: ${materialTmz.codeitem}',
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Seller: ${materialTmz.sellerTmzContact}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              'Country: ${materialTmz.sellerTmzCountry}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Model: ${materialTmz.tmzModel}',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onLongPress: () {
                              setState(() {
                                selectedIndex =
                                    (selectedIndex == index) ? -1 : index;
                                checkAppBar = 'Иконки';
                                selectedItem = materialTmz.id;
                                tmzSelected.add(materialTmz.id);
                              });
                            },
                            child: Dismissible(
                              key: Key(materialTmz.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  tmzMaterial.removeAt(index);
                                });
                                deleteTMZbyID(materialTmz.id);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Card(
                                  color: isSelected
                                      ? const Color.fromARGB(255, 138, 255, 199)
                                      : Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                materialTmz.itemTmzName,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                  'Item code: ${materialTmz.codeitem}',
                                                  style: TextStyle(
                                                      color: Colors.grey[700])),
                                              SizedBox(height: 8),
                                              Text(
                                                'Seller: ${materialTmz.sellerTmzContact}',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                              Text(
                                                'Country: ${materialTmz.sellerTmzCountry}',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Model: ${materialTmz.tmzModel}',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    TMZMaterialDetailPage(
                                                        material: materialTmz),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(-1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve = Curves.ease;

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
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
                                ),
                              ),
                            ),
                          );
                  },
                )),
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
                              child: Text('Новое ТМЗ', style: textH1),
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
