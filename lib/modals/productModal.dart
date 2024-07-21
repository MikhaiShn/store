// To parse this JSON data, do
//
//     final finishedProduct = finishedProductFromJson(jsonString);

import 'dart:convert';

List<FinishedProduct> finishedProductFromJson(String str) => List<FinishedProduct>.from(json.decode(str).map((x) => FinishedProduct.fromJson(x)));

String finishedProductToJson(List<FinishedProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FinishedProduct {
    String id;
    String item;
    String bin;
    String manufacturerIndustry;
    String comment;
    List<ItemModelProduct> itemModels;
    int v;

    FinishedProduct({
        required this.id,
        required this.item,
        required this.bin,
        required this.manufacturerIndustry,
        required this.comment,
        required this.itemModels,
        required this.v,
    });

    factory FinishedProduct.fromJson(Map<String, dynamic> json) => FinishedProduct(
        id: json["_id"],
        item: json["item"],
        bin: json["bin"],
        manufacturerIndustry: json["manufacturerIndustry"],
        comment: json["comment"],
        itemModels: List<ItemModelProduct>.from(json["itemModels"].map((x) => ItemModelProduct.fromJson(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "item": item,
        "bin": bin,
        "manufacturerIndustry": manufacturerIndustry,
        "comment": comment,
        "itemModels": List<dynamic>.from(itemModels.map((x) => x.toJson())),
        "__v": v,
    };
}

class ItemModelProduct {
    String modelName;
    int summaSebestoimostPrice;
    int summaProdazhaPrice;
    int productAllQuantity;
    String productSezon;
    String productComment;
    String productPerson;
    String productColor;
    String codeGtin;
    List<SizeVariationProduct> sizeVariations;
    String id;

    ItemModelProduct({
        required this.modelName,
        required this.summaSebestoimostPrice,
        required this.summaProdazhaPrice,
        required this.productAllQuantity,
        required this.productSezon,
        required this.productComment,
        required this.productPerson,
        required this.productColor,
        required this.codeGtin,
        required this.sizeVariations,
        required this.id,
    });

    factory ItemModelProduct.fromJson(Map<String, dynamic> json) => ItemModelProduct(
        modelName: json["modelName"],
        summaSebestoimostPrice: json["summaSebestoimostPrice"],
        summaProdazhaPrice: json["summaProdazhaPrice"],
        productAllQuantity: json["productAllQuantity"],
        productSezon: json["productSezon"],
        productComment: json["productComment"],
        productPerson: json["productPerson"],
        productColor: json["productColor"],
        codeGtin: json["codeGTIN"],
        sizeVariations: List<SizeVariationProduct>.from(json["sizeVariations"].map((x) => SizeVariationProduct.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "modelName": modelName,
        "summaSebestoimostPrice": summaSebestoimostPrice,
        "summaProdazhaPrice": summaProdazhaPrice,
        "productAllQuantity": productAllQuantity,
        "productSezon": productSezon,
        "productComment": productComment,
        "productPerson": productPerson,
        "productColor": productColor,
        "codeGTIN": codeGtin,
        "sizeVariations": List<dynamic>.from(sizeVariations.map((x) => x.toJson())),
        "_id": id,
    };
}

class SizeVariationProduct {
    String size;
    int costSebestoimostPrice;
    int costProdazhaPrice;
    String codeitem;
    String productSizeComment;
    int productSizeQuantity;
    String productSizeUnit;
    String id;

    SizeVariationProduct({
        required this.size,
        required this.costSebestoimostPrice,
        required this.costProdazhaPrice,
        required this.codeitem,
        required this.productSizeComment,
        required this.productSizeQuantity,
        required this.productSizeUnit,
        required this.id,
    });

    factory SizeVariationProduct.fromJson(Map<String, dynamic> json) => SizeVariationProduct(
        size: json["size"],
        costSebestoimostPrice: json["costSebestoimostPrice"],
        costProdazhaPrice: json["costProdazhaPrice"],
        codeitem: json["codeitem"],
        productSizeComment: json["productSizeComment"],
        productSizeQuantity: json["productSizeQuantity"],
        productSizeUnit: json["productSizeUnit"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "size": size,
        "costSebestoimostPrice": costSebestoimostPrice,
        "costProdazhaPrice": costProdazhaPrice,
        "codeitem": codeitem,
        "productSizeComment": productSizeComment,
        "productSizeQuantity": productSizeQuantity,
        "productSizeUnit": productSizeUnit,
        "_id": id,
    };
}
