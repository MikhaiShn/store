import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/shopMaterials(%D0%A1%D1%8B%D1%80%D1%8C%D1%91).dart';
import 'package:shop_apllication_1/shop.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
export '../globals.dart';

Color greyTransparentColor = Color.fromRGBO(238, 236, 236, 0.938);
Color color = Colors.blue;
TextStyle textH1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle textH2 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

Widget buildTextFormField(String labelText, TextEditingController controller) {
  //Это метод для создания текстовых полей для ввода
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

Widget buildOrderRow(
    //Метод для создания "каркасов" заказа
    Color color,
    BuildContext context,
    List<Order>? orders,
    int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ID заказа: ${orders?[index].id ?? 'Unknown'}"),
                    Text("Продукт: ${orders?[index].product ?? 'Unknown'}"),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(orders?[index].id ?? 'Unknown'),
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
  );
}

class Order {
  final String id;
  final String product;

  Order({
    required this.id,
    required this.product,
  });

  static fromJson(json) {}
}

// Widget proccessingOrders(BuildContext context) {
//   return buildOrderRow(
//       const Color.fromARGB(255, 209, 209, 209).withOpacity(0.4), context);
// }

// Widget completedOrders(BuildContext context) {
//   return buildOrderRow(Colors.green.withOpacity(0.4), context);
// }

PreferredSizeWidget appbarTitle(String titlePage) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets1/logo.png',
          fit: BoxFit.contain,
          height: 50,
        ),
        Text(
          titlePage,
          style: textH1,
        ),
        SizedBox(
          width: 30,
        )
      ],
    ),
  );
}

Widget buildBottomNavigatorBar(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white, // Цвет фона
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // Цвет тени
          blurRadius: 4, // Радиус размытия
          offset: Offset(0, -2), // Смещение тени
        ),
      ],
    ),
    child: BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.green,
      unselectedFontSize: 13,
      selectedFontSize: 13,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets1/icon_home.png'),
            size: 15,
          ),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets1/icon_journal.png'),
            size: 15,
          ),
          label: 'Журнал',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets1/icon_materials.png'),
            size: 15,
          ),
          label: 'Сырье',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets1/iconTMZ.png'),
            size: 15,
          ),
          label: 'ТМЗ',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets1/icon_menu.png'),
            size: 15,
          ),
          label: 'Меню',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Shop()));
        }
        if (index == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShopMaterials()));
        }
        // if (index == 2) {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => ShopProfile()));
        // }
        // if (index == 3) {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => ShopMenu()));
        // }
      },
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      unselectedLabelStyle:
          TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    ),
  );
}

Widget buildContainerMaterials(
    String title, BuildContext context, Widget clazz) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => clazz));
    },
    child: Container(
      height: 40,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 212, 30).withOpacity(0.4),
          border: Border.all(color: Colors.black, width: 0.15)),
      child: Center(child: Text(title)),
    ),
  );
}

Widget buildAddButton(BuildContext context, VoidCallback onPressedCallback) {
  return FloatingActionButton(
    onPressed: onPressedCallback,
    child: Icon(Icons.add),
    backgroundColor:
        Color.fromARGB(255, 6, 201, 12).withOpacity(0.4), // Цвет фона кнопки
    foregroundColor: Colors.white, // Цвет иконки
  );
}

File? photo;
//Метод для создании контейнера при нажатии которого будет доступ к галерее
Future<void> pickImageFromGallery(
    void Function(void Function()) setStateCallback) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    setStateCallback(() {
      photo = File(image.path);
    });
  }
}
