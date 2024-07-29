// To parse this JSON data, do
//
//     final tmzManufacturer = tmzManufacturerFromJson(jsonString);

import 'dart:convert';

TmzManufacturer tmzManufacturerFromJson(String str) => TmzManufacturer.fromJson(json.decode(str));

String tmzManufacturerToJson(TmzManufacturer data) => json.encode(data.toJson());

class TmzManufacturer {
  String id;
  String bin;
  String manufacturerIndustry;
  String item;
  List<TMZMaterial> materials;
  int version;

  TmzManufacturer({
    required this.id,
    required this.bin,
    required this.manufacturerIndustry,
    required this.item,
    required this.materials,
    required this.version,
  });

  factory TmzManufacturer.fromJson(Map<String, dynamic> json) => TmzManufacturer(
    id: json["_id"],
    bin: json["bin"],
    manufacturerIndustry: json["manufacturerIndustry"],
    item: json["item"],
    materials: List<TMZMaterial>.from(json["materials"].map((x) => TMZMaterial.fromJson(x))),
    version: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bin": bin,
    "manufacturerIndustry": manufacturerIndustry,
    "item": item,
    "materials": List<dynamic>.from(materials.map((x) => x.toJson())),
    "__v": version,
  };
}

class TMZMaterial {
  String groupName;
  String id;
  List<Item> items;

  TMZMaterial({
    required this.groupName,
    required this.id,
    required this.items,
  });

  factory TMZMaterial.fromJson(Map<String, dynamic> json) => TMZMaterial(
    groupName: json["groupName"],
    id: json["_id"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "groupName": groupName,
    "_id": id,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String itemTmzName;
  String sellerBin;
  String sellerTmzContact;
  String sellerTmzCountry;
  bool itemImport;
  String codeitem;
  String tmzSezon;
  String tmzModel;
  String tmzComment;
  String tmzPerson;
  String tmzSize;
  String tmzColor;
  String tmzExpiryDate;
  int tmzQuantity;
  String tmzUnit;
  int tmzPurchaseprice;
  int tmzSellingprice;
  String id;
  int tmzTotalPurchase;
  int tmzTotalSelling;

  Item({
    required this.itemTmzName,
    required this.sellerBin,
    required this.sellerTmzContact,
    required this.sellerTmzCountry,
    required this.itemImport,
    required this.codeitem,
    required this.tmzSezon,
    required this.tmzModel,
    required this.tmzComment,
    required this.tmzPerson,
    required this.tmzSize,
    required this.tmzColor,
    required this.tmzExpiryDate,
    required this.tmzQuantity,
    required this.tmzUnit,
    required this.tmzPurchaseprice,
    required this.tmzSellingprice,
    required this.id,
    required this.tmzTotalPurchase,
    required this.tmzTotalSelling,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemTmzName: json["itemTmzName"],
    sellerBin: json["sellerBIN"],
    sellerTmzContact: json["sellerTMZContact"],
    sellerTmzCountry: json["sellerTMZCountry"],
    itemImport: json["import"],
    codeitem: json["codeitem"],
    tmzSezon: json["tmzSezon"],
    tmzModel: json["tmzModel"],
    tmzComment: json["tmzComment"],
    tmzPerson: json["tmzPerson"],
    tmzSize: json["tmzSize"],
    tmzColor: json["tmzColor"],
    tmzExpiryDate:json["tmzExpiryDate"],
    tmzQuantity: json["tmzQuantity"],
    tmzUnit: json["tmzUnit"],
    tmzPurchaseprice: json["tmzPurchaseprice"],
    tmzSellingprice: json["tmzSellingprice"],
    id: json["_id"],
    tmzTotalPurchase: json["tmzTotalPurchase"],
    tmzTotalSelling: json["tmzTotalSelling"],
  );

  Map<String, dynamic> toJson() => {
    "itemTmzName": itemTmzName,
    "sellerBIN": sellerBin,
    "sellerTMZContact": sellerTmzContact,
    "sellerTMZCountry": sellerTmzCountry,
    "import": itemImport,
    "codeitem": codeitem,
    "tmzSezon": tmzSezon,
    "tmzModel": tmzModel,
    "tmzComment": tmzComment,
    "tmzPerson": tmzPerson,
    "tmzSize": tmzSize,
    "tmzColor": tmzColor,
    "tmzExpiryDate": tmzExpiryDate,
    "tmzQuantity": tmzQuantity,
    "tmzUnit": tmzUnit,
    "tmzPurchaseprice": tmzPurchaseprice,
    "tmzSellingprice": tmzSellingprice,
    "_id": id,
    "tmzTotalPurchase": tmzTotalPurchase,
    "tmzTotalSelling": tmzTotalSelling,
  };
}
