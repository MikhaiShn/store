import 'package:flutter/material.dart';

class PrintBinClient extends StatelessWidget {
  final String binClient;

  const PrintBinClient({Key? key, required this.binClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print Bin Client')),
      body: Center(
        child: Text('BIN: $binClient'),
      ),
    );
  }
}
