import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shopLogIn(%D0%90%D0%B2%D1%82%D0%BE%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F).dart';

class ShopSplash extends StatefulWidget {
  const ShopSplash({super.key});

  @override
  State<ShopSplash> createState() => _SplashState();
}

class _SplashState extends State<ShopSplash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ShopLogIn()), // Navigate to NextScreen after 5 seconds
      );
    });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets1/splash.jpeg'), // Provide your image path here
          fit: BoxFit.cover, // Set fit property to cover the container
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
