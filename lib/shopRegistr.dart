import 'dart:convert';
import 'globals.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/shopLoginModal.dart';
import 'methods/methodGalery.dart';
import 'package:shop_apllication_1/shopProfile.dart';

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
      Uri.parse('http://10.0.2.2:3000/register/manufacturer'),
    );

    print('hh: ${response.body}');
    print(response.statusCode);

    if (response.statusCode == 200) {
      StoreRegister shopRegister =
          StoreRegister.fromJson(jsonDecode(response.body));
      shopRegister.manufacturerName = companySelerNameFile.text;
      shopRegister.manufacturerContact = companySelerContactFile.text;
      shopRegister.manufacturerCountry = companySelerCountryFile.text;
      shopRegister.manufacturerEmail = companySelerEmailFile.text;
      shopRegister.bIN = companySelerbIN.text;
      shopRegister.manufacturerAdress = companySelerAdress.text;
      shopRegister.manufacturerLogo = companySelerLogo.text;
      shopRegister.manufacturerInfo = companySelerInfo.text;
      shopRegister.manufacturerIndustry = companySelerIndustry.text;
    } else {
      throw 'Ошибка';
    }
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
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyTransparentColor,
              ),
              child: InkWell(
                onTap:() {
                  pickImageFromGallery(setState);
                },
                child: Center(
                  child: photo != null
                      ? Image.file(
                          photo!,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          'Выбрать фото',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                ),
              ),
            ),
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
                  setState(() {
                    postInfoFromServer();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopProfile()));
                  });
                },
                child: Text('Зарегистрироваться')),
            Text(companySelerAdress.text),
          ],
        ),
      ),
    );
  }
}
