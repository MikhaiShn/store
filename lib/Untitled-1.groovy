import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/calculateModals.dart';

class ShopCalculation extends StatefulWidget {
  String token;
  ShopCalculation({super.key, required this.token});

  @override
  State<ShopCalculation> createState() => _ShopCalculationState();
}

class _ShopCalculationState extends State<ShopCalculation> {
  List<CalculateModal> calculate = [];
  bool isLoading = false;
  int? expandedIndex;

  void toggleExpand(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  Future<void> getCompleteModal() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        });
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      calculate =
          responseBody.map((data) => CalculateModal.fromJson(data)).toList();
      print('Калькуляция успешно получена');
      isLoading = false;
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompleteModal();
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Калькуляция'),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : calculate.isEmpty
            ? Center(child: Text('Данные о калькуляции отсутствуют'))
            : ListView.builder(
                itemCount: calculate.length,
                itemBuilder: (context, index) {
                  final takeListCalculate = calculate[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          title: ListTile(
                            title: Text('BIN: ${takeListCalculate.bin}'),
                            subtitle: Text('Производственная отрасль: ${takeListCalculate.manufacturerIndustry}'),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Комментарий: ${takeListCalculate.comment}'),
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: takeListCalculate.itemModels.length,
                              itemBuilder: (context, idx) {
                                final itemModel = takeListCalculate.itemModels[idx];
                                return ExpansionTile(
                                  title: Text(itemModel.modelName),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: itemModel.sizeVariations.length,
                                      itemBuilder: (context, sizeIdx) {
                                        final sizeVariation = itemModel.sizeVariations[sizeIdx];
                                        return ListTile(
                                          title: Text('Размер: ${sizeVariation.size}'),
                                          subtitle: Text('Компоненты: ${sizeVariation.components.length}'),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
  );
}
}
