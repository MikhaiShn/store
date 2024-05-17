import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ShopRegister extends StatefulWidget {
  const ShopRegister({super.key});

  @override
  State<ShopRegister> createState() => _ShopRegisterState();
}

class _ShopRegisterState extends State<ShopRegister> {
  TextEditingController companySelerNameFile = TextEditingController();
  TextEditingController companySelerCountryFile = TextEditingController();
  TextEditingController companySelerContactFile = TextEditingController();
  TextEditingController companySelerEmailFile = TextEditingController();
  TextEditingController companySelerAdminPasswordFile = TextEditingController();
  TextEditingController companySelerAdress = TextEditingController();
  TextEditingController companySelerIndustry = TextEditingController();
  TextEditingController companySelerInfo = TextEditingController();
  TextEditingController companySelerLogo = TextEditingController();
  TextEditingController companySelerbIN = TextEditingController();
  Color greyTransparentColor = Color.fromRGBO(128, 128, 128, 0.5);
  File? photo;

  Future<void> _pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        photo = File(image.path);
      });
    }
  }

  Widget buildTextFormField(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

Future<void> postInfoFromServer() async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/register/manufacturer'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'manufacturerName': companySelerNameFile.text,
      'manufacturerContact': companySelerContactFile.text,
      'manufacturerCountry': companySelerCountryFile.text,
      'manufacturerEmail': companySelerEmailFile.text,
      'bIN': companySelerbIN.text,
      'manufacturerAdress': companySelerAdress.text,
      'manufacturerLogo': companySelerLogo.text,
      'manufacturerInfo': companySelerInfo.text,
      'manufacturerIndustry': companySelerIndustry.text,
    }),
  );

  final responseData = jsonDecode(response.body);//перевод формат json на dart
  final message = responseData['message'];

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),//всплывающее меню с ответом от сервера
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Регистрация')),
        ),
        backgroundColor: const Color.fromARGB(255, 141, 102, 88),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            /*Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyTransparentColor,
              ),
              child: InkWell(
                onTap: _pickImageFromGallery,
                child: Center(
                  child: photo != null
                      ? Image.file(
                          photo!,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          'Выбрать фото',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),
            ),*/
            SizedBox(height: 20),
            buildTextFormField('Наименование компании', companySelerNameFile),
            buildTextFormField('Казахстан', companySelerCountryFile),
            buildTextFormField('Номер телефона', companySelerContactFile),
            buildTextFormField('email', companySelerEmailFile),
            buildTextFormField('Адресс', companySelerAdress),
            buildTextFormField('Инфо', companySelerInfo),
            buildTextFormField('БИИН', companySelerbIN),
            buildTextFormField('Logo', companySelerLogo),
            buildTextFormField('Индустрия', companySelerIndustry),
            ElevatedButton(
                onPressed: () {
                  postInfoFromServer();
                },
                child: Text('Зарегистрироваться'))
          ],
        ),
      ),
    );
  }
}
