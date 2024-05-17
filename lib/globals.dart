import 'package:flutter/material.dart';
export 'globals.dart';
Color greyTransparentColor = Color.fromRGBO(128, 128, 128, 0.5);
Color brown = const Color.fromARGB(255, 141, 102, 88);



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