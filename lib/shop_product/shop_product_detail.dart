import 'package:flutter/material.dart';
import 'package:shop_apllication_1/modals_file/product_modals.dart';

class ShopProductDetail extends StatefulWidget {
  ShopProductDetail({super.key, required this.sizeVariationProduct});
  List<SizeVariationProduct> sizeVariationProduct;
  @override
  State<ShopProductDetail> createState() => _ShopProductDetailState();
}

class _ShopProductDetailState extends State<ShopProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.sizeVariationProduct.length,
        itemBuilder: (context, index) {
          final sizeVariation = widget.sizeVariationProduct[index];
          return ExpansionTile(
            title: Text('Размер: ${sizeVariation.size}'),
            children: [
              ListTile(
                title: Text('Цвет: ${sizeVariation.productSizeQuantity}'),
                subtitle:
                    Text('Количество: ${sizeVariation.costProdazhaPrice}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
