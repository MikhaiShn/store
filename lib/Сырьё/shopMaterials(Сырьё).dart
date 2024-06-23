import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopMaterials(),
    );
  }
}

class ShopMaterials extends StatefulWidget {
  const ShopMaterials({super.key});

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  TextEditingController newMaterials = TextEditingController();
  List<String> materialsList = []; // Список для хранения материалов

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Светло-серый фон
      appBar: AppBar(
        title: Text('Сырьё'),
        backgroundColor: Colors.blue,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Переход на страницу с деталями материала
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MaterialDetailPage(material: materialsList[index]),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Белый цвет для контейнеров
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Цвет тени
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Смещение тени
                        ),
                      ],
                    ),
                    child: Text(
                      materialsList[index],
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              },
              childCount: materialsList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextFormField('Добавьте новое сырьё', newMaterials),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          materialsList.add(newMaterials.text);
                          newMaterials.clear();
                          Navigator.pop(
                              context); // Закрываем диалоговое окно после добавления
                        });
                      },
                      child: Text('Добавить'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class MaterialDetailPage extends StatelessWidget {
  final String material;

  const MaterialDetailPage({required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Детали материала: $material'),
      ),
    );
  }
}

Widget buildTextFormField(String labelText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
