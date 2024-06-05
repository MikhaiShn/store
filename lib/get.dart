import "package:flutter/material.dart";

class Papirosa extends StatefulWidget {
  const Papirosa({super.key});

  @override
  State<Papirosa> createState() => _PapirosaState();
}

class _PapirosaState extends State<Papirosa> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple PageView Example'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Container(
              height: 100,
              color: Colors.blue,
              child: Center(
                child: Text('Page 1',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Container(
              height: 100,
              color: Colors.green,
              child: Center(
                child: Text('Page 2',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
