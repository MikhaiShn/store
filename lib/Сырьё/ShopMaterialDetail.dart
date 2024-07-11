import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart';

class MaterialDetailPage extends StatefulWidget {
  final String? token;
  final Future<void> Function() getMaterial;
  final List<RawMaterial> rawMaterial;
  final String groupName;
  final String idIndustry;
  final String idGroup;
  MaterialDetailPage({
    Key? key,
    required this.rawMaterial,
    required this.token,
    required this.getMaterial,
    required this.groupName,
    required this.idIndustry,
    required this.idGroup,
  }) : super(key: key);

  @override
  _MaterialDetailPageState createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
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
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items'),
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

  void navigateToDetailPage(RawMaterial material) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RawMaterialDetailPage(material: material),
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
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items/$idMaterial'));
    if (response.statusCode == 200) {
      print('Raw material deleted successfully');
    } else {
      print('Failed to delete raw material: ${response.statusCode}');
    }
  }

  List<RawMaterial> rawMaterial = [];

  Future<void> getMaterialInGroup() async {
    final response = await http.get(Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items'));
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      List<RawMaterial> getListMaterial = responseBody
          .map((data) => RawMaterial.fromJson(data as Map<String, dynamic>))
          .toList();
      setState(() {
        rawMaterial = getListMaterial;
      });
    }
  }

Future<void> updateMaterialDetail(String idMaterial) async {
  try {
    final response = await http.put(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/${widget.idIndustry}/groups/${widget.idGroup}/items/$idMaterial'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raw Material Details'),
      ),
      body: ListView.builder(
        itemCount: rawMaterial.length,
        itemBuilder: (context, index) {
          final material = rawMaterial[index];
          return Dismissible(
            key: Key(material.id),
            confirmDismiss: (direction) async {
              await deleteRawMaterial(material.id);
              return true;
            },
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(material.rawModel),
                subtitle: Text('Item Code: ${material.codeitem}'),
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
                                          'Item Name', itemRawNameController),
                                      buildTextFormField(
                                          'Seller BIN', sellerRawBINController),
                                      buildTextFormField('Seller Contact',
                                          selerRawContactController),
                                      buildTextFormField('Seller Country',
                                          selerRawCountryController),
                                      buildTextFormField('Import (true/false)',
                                          rawImportController),
                                      buildTextFormField(
                                          'Item Code', rawCodeitemController),
                                      buildTextFormField(
                                          'Raw Season', rawSezonController),
                                      buildTextFormField(
                                          'Raw Model', rawModelController),
                                      buildTextFormField(
                                          'Raw Comment', rawCommentController),
                                      buildTextFormField(
                                          'Raw Person', rawPersonController),
                                      buildTextFormField(
                                          'Raw Size', rawSizeController),
                                      buildTextFormField(
                                          'Raw Color', rawColorController),
                                      buildTextFormField(
                                          'Quantity', rawQuantityController),
                                      buildTextFormField(
                                          'Unit', rawUnitController),
                                      buildTextFormField('Purchase Price',
                                          rawPurchasepriceController),
                                      buildTextFormField('Selling Price',
                                          rawSellingpriceController),
                                      buildTextFormField('Expiry Date',
                                          rawExpiryDateController),
                                      ElevatedButton(
                                        onPressed: () {
                                          updateMaterialDetail(material.id);
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
                        navigateToDetailPage(material);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
  final RawMaterial material;

  const RawMaterialDetailPage({Key? key, required this.material})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали Сырья: ${material.rawModel}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailCard('Название предмета', material.itemRawName),
              buildDetailCard('BIN продавца', material.sellerBin),
              buildDetailCard('Контакт продавца', material.sellerRawContact),
              buildDetailCard('Страна продавца', material.sellerRawCountry),
              buildDetailCard('Импорт', material.itemImport ? 'Да' : 'Нет'),
              buildDetailCard('Код предмета', material.codeitem),
              buildDetailCard('Сезон сырья', material.rawSezon),
              buildDetailCard('Модель сырья', material.rawModel),
              buildDetailCard('Комментарий к сырью', material.rawComment),
              buildDetailCard('Ответственное лицо', material.rawPerson),
              buildDetailCard('Размер сырья', material.rawSize),
              buildDetailCard('Цвет сырья', material.rawColor),
              buildDetailCard('Количество', material.rawQuantity.toString()),
              buildDetailCard('Единица измерения', material.rawUnit),
              buildDetailCard(
                  'Закупочная цена', material.rawPurchaseprice.toString()),
              buildDetailCard(
                  'Цена продажи', material.rawSellingprice.toString()),
              buildDetailCard('Срок годности', material.rawExpiryDate),
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
