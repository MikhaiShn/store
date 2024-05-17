import 'package:flutter/material.dart';
import 'globals.dart';
import 'methods/methodGalery.dart';
class ShopProfile extends StatefulWidget {
  const ShopProfile({super.key});

  @override
  State<ShopProfile> createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brown,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyTransparentColor,
              ),
              child: InkWell(
                onTap: () {
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
          ),
          Text(' '),
          Text(' '),
          Text(' '),
          Text(' '),
          Text(' '),
          Text(' '),
          Text(' '),
          Text(' '),
        ],
      ),
    );
  }
}
