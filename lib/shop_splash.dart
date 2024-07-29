import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shop_auth.dart';

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
