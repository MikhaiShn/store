import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopJournal extends StatefulWidget {
  const ShopJournal({Key? key}) : super(key: key);

  @override
  State<ShopJournal> createState() => _ShopJournalState();
}

class _ShopJournalState extends State<ShopJournal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildSliverAppbar('Журнал'),
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
