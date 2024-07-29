import 'package:flutter/material.dart';
import 'package:shop_apllication_1/modals_file/tmz_modals.dart';

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
