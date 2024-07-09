import 'package:flutter/material.dart';
import 'dart:io';
export 'package:shop_apllication_1/globals.dart';

Color greyTransparentColor = Color.fromRGBO(238, 236, 236, 0.938);
Color color = Color.fromARGB(255, 57, 86, 218).withOpacity(0.5);
TextStyle textH1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle textH2 = TextStyle(fontSize: 18);
TextStyle textH3 = TextStyle(fontSize: 20);
String? binClient;
String? role;
File? photo;
String? token;
String? manufacturerIndustryName;

//Заказы
TextEditingController zakazModelController = TextEditingController();
TextEditingController zakazSizeController = TextEditingController();
TextEditingController zakazColorController = TextEditingController();
TextEditingController zakazQuantityController = TextEditingController();
TextEditingController zakazUnitController = TextEditingController();
TextEditingController zakazSellingpriceController = TextEditingController();
TextEditingController zakazTotalSellingController = TextEditingController();
TextEditingController zakazCommentController = TextEditingController();
TextEditingController zakazBinController = TextEditingController();
TextEditingController zakazManufacturerController = TextEditingController();
TextEditingController binPokupatelController = TextEditingController();
TextEditingController namePokupatelController = TextEditingController();
TextEditingController contactPokupatelController = TextEditingController();

//Сырьё
TextEditingController itemRawNameController = TextEditingController();
TextEditingController sellerRawBINController = TextEditingController();
TextEditingController selerRawCountryController = TextEditingController();
TextEditingController importController = TextEditingController();
TextEditingController codeitemController = TextEditingController();
TextEditingController rawSezonController = TextEditingController();
TextEditingController rawModelController = TextEditingController();
TextEditingController rawCommentController = TextEditingController();
TextEditingController rawPersonController = TextEditingController();
TextEditingController rawSizeController = TextEditingController();
TextEditingController rawColorController = TextEditingController();
TextEditingController rawExpiryDateController = TextEditingController();
TextEditingController rawQuantityController = TextEditingController();
TextEditingController rawUnitController = TextEditingController();
TextEditingController rawPurchasepriceController = TextEditingController();
TextEditingController rawSellingpriceController = TextEditingController();
TextEditingController rawGroupNameController = TextEditingController();
TextEditingController selerRawContactController = TextEditingController();
TextEditingController newRawGroupController = TextEditingController();

//ТМЗ
TextEditingController tmzIDController = TextEditingController();
TextEditingController itemTmzNameController = TextEditingController();
TextEditingController sellerBINController = TextEditingController();
TextEditingController sellerTMZContactController = TextEditingController();
TextEditingController sellerTMZCountryController = TextEditingController();
TextEditingController codeItemController = TextEditingController();
TextEditingController tmzSezonController = TextEditingController();
TextEditingController tmzModelController = TextEditingController();
TextEditingController tmzCommentController = TextEditingController();
TextEditingController tmzPersonController = TextEditingController();
TextEditingController tmzSizeController = TextEditingController();
TextEditingController tmzColorController = TextEditingController();
TextEditingController tmzExpiryDateController = TextEditingController();
TextEditingController tmzQuantityController = TextEditingController();
TextEditingController tmzUnitController = TextEditingController();
TextEditingController tmzPurchasepriceController = TextEditingController();
TextEditingController tmzSellingpriceController = TextEditingController();

TextEditingController tmzGroupNameController =
    TextEditingController(); // Assuming this is for _id

int index = -1;
String getModal = ' ';
List<dynamic> quantityProduct = [];
List<String> modalProduct = [];

Widget buildSliverAppbar(String title) {
  return SliverAppBar(
    pinned: false, // Оставаться видимым при прокрутке вниз
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets1/logo.png',
            fit: BoxFit.cover,
            height: AppBar().preferredSize.height,
          ),
          SizedBox(width: 8), // добавляем отступ между логотипом и текстом
          Text(
            title,
            style: textH1,
          ),
        ],
      ),
    ),
    toolbarHeight: 80,
    floating: false,
  );
}

//Метод для создания TextFormField
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

Widget buildPageViewContainer(String title, Color colors) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      constraints: BoxConstraints.expand(
          width: double.infinity, height: double.infinity),
      decoration: BoxDecoration(
          color: colors, borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: Text(title, style: textH1),
      ),
    ),
  );
}

//Метод для создания контейнера перехода на странице сырья
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

//Метод для создания кнопки добавления
Widget buildAddButton(BuildContext context, VoidCallback onPressedCallback) {
  return FloatingActionButton(
    onPressed: onPressedCallback,
    child: Align(alignment: Alignment.center, child: Icon(Icons.add)),
    backgroundColor:
        Color.fromARGB(255, 6, 201, 12).withOpacity(0.4), // Цвет фона кнопки
    foregroundColor: Colors.white, // Цвет иконки
  );
}

// //Метод для создании контейнера при нажатии которого будет доступ к галерее
// Future<void> pickImageFromGallery(
//     void Function(void Function()) setStateCallback) async {
//   ImagePicker imagePicker = ImagePicker();
//   XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
//   if (image != null) {
//     setStateCallback(() {
//       photo = File(image.path);
//     });
//   }
// }

//Метод для создания заказа

Widget buildOrderRow(
  BuildContext context,
  String namePokupatel,
  String contactPokupatel,
  String binPokupatel,
  String bin,
  String manufacturerName,
  int zakazID,
  String model,
  String size,
  String colorZakaz,
  num sellingPrice,
  int quantity,
  int productAvailability,
  Function(String) onDelete,
  String sId,
  Function(String) updateStatus,
  String status,
  Function(String) updateZakaz,
) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text('БИН Организации: $binClient',style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Название организации: $manufacturerIndustryName',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Бин покупателя: $binPokupatel'),
                        Text('Название покупателя $namePokupatel'),
                        Text('Контакты покупателя $contactPokupatel'),
                        Text('Номер заказа: $zakazID',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Модель: $model',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Размер: $size',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Цвет: $colorZakaz',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Количество: $quantity',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Стоимость: $sellingPrice',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('id: $sId'),
                        Text('Статус $status'),
                        ElevatedButton(
                          onPressed: () {
                            updateStatus(sId);
                            Navigator.of(context)
                                .pop(); // Закрытие диалога после обновления
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text('Выполнено'),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Действие по нажатию на иконку
                      // Можно открыть другой диалог для редактирования
                      Navigator.of(context).pop(); // Закрытие текущего диалога
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.7,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildTextFormField(
                                          'Модель заказа', zakazModelController),
                                      buildTextFormField(
                                          'Размер', zakazSizeController),
                                      buildTextFormField(
                                          'Цвет', zakazColorController),
                                      buildTextFormField(
                                          'Количество', zakazQuantityController),
                                      buildTextFormField('Единица измерения',
                                          zakazUnitController),
                                      buildTextFormField('Цена продажи',
                                          zakazSellingpriceController),
                                      buildTextFormField(
                                          'Комментарии', zakazCommentController),
                                      Text('Редактировать заказ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      // Здесь добавьте поля для редактирования заказа
                                      ElevatedButton(
                                        onPressed: () {
                                          updateZakaz(sId);
                                          Navigator.of(context)
                                              .pop(); // Закрытие диалога после обновления
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: Text('Сохранить изменения'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Номер заказа: $zakazID',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          SizedBox(height: 4),
          Text(
            'Модель: $model',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'На складе: $productAvailability',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                'Нужное кол-во: $quantity шт',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//Метод для создания заказа с showMenu
Widget buildQuantityField(
    BuildContext context,
    TextEditingController controller,
    Function(String) methods,
    List<String> getProduct) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            labelText: 'Наименование',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: PopupMenuButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            onSelected: methods,
            itemBuilder: (BuildContext context) {
              return getProduct.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ),
      ],
    ),
  );
}

//Метод для создания нижней панели навигации
Widget buildBottomNavigatorBar(
    BuildContext context, int selectedIndex, void Function(int) onItemTapped) {
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
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      unselectedLabelStyle:
          TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    ),
  );
}
