// To parse this JSON data, do
//
//     final manufacturer = manufacturerFromJson(jsonString);

import 'dart:convert';

Manufacturer manufacturerFromJson(String str) => Manufacturer.fromJson(json.decode(str));

String manufacturerToJson(Manufacturer data) => json.encode(data.toJson());

class Manufacturer {
    String id;
    String bin;
    String manufacturerIndustry;
    String item;
    List<Material> materials;
    int v;

    Manufacturer({
        required this.id,
        required this.bin,
        required this.manufacturerIndustry,
        required this.item,
        required this.materials,
        required this.v,
    });

    factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
        id: json["_id"],
        bin: json["bin"],
        manufacturerIndustry: json["manufacturerIndustry"],
        item: json["item"],
        materials: List<Material>.from(json["materials"].map((x) => Material.fromJson(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bin": bin,
        "manufacturerIndustry": manufacturerIndustry,
        "item": item,
        "materials": List<dynamic>.from(materials.map((x) => x.toJson())),
        "__v": v,
    };
}

class Material {
    String groupName;
    String id;
    List<RawMaterial> items;

    Material({
        required this.groupName,
        required this.id,
        required this.items,
    });

    factory Material.fromJson(Map<String, dynamic> json) => Material(
        groupName: json["groupName"],
        id: json["_id"],
        items: List<RawMaterial>.from(json["items"].map((x) => RawMaterial.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "_id": id,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class RawMaterial {
  String itemRawName;
  String sellerBin;
  String sellerRawContact;
  String sellerRawCountry;
  bool itemImport;
  String codeitem;
  String rawSezon;
  String rawModel;
  String rawComment;
  String rawPerson;
  String rawSize;
  String rawColor;
  String rawExpiryDate;
  int rawQuantity;
  String rawUnit;
  int rawPurchaseprice;
  int rawSellingprice;
  String id;
  int rawTotalPurchase;
  int rawTotalSelling;

  RawMaterial({
    required this.itemRawName,
    required this.sellerBin,
    required this.sellerRawContact,
    required this.sellerRawCountry,
    required this.itemImport,
    required this.codeitem,
    required this.rawSezon,
    required this.rawModel,
    required this.rawComment,
    required this.rawPerson,
    required this.rawSize,
    required this.rawColor,
    required this.rawExpiryDate,
    required this.rawQuantity,
    required this.rawUnit,
    required this.rawPurchaseprice,
    required this.rawSellingprice,
    required this.id,
    required this.rawTotalPurchase,
    required this.rawTotalSelling,
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) => RawMaterial(
    itemRawName: json["itemRawName"],
    sellerBin: json["sellerBIN"],
    sellerRawContact: json["sellerRawContact"],
    sellerRawCountry: json["sellerRawCountry"],
    itemImport: json["import"],
    codeitem: json["codeitem"],
    rawSezon: json["rawSezon"],
    rawModel: json["rawModel"],
    rawComment: json["rawComment"],
    rawPerson: json["rawPerson"],
    rawSize: json["rawSize"],
    rawColor: json["rawColor"],
    rawExpiryDate: json["rawExpiryDate"],
    rawQuantity: json["rawQuantity"],
    rawUnit: json["rawUnit"],
    rawPurchaseprice: json["rawPurchaseprice"],
    rawSellingprice: json["rawSellingprice"],
    id: json["_id"],
    rawTotalPurchase: json["rawTotalPurchase"],
    rawTotalSelling: json["rawTotalSelling"],
  );

  Map<String, dynamic> toJson() => {
    "itemRawName": itemRawName,
    "sellerBIN": sellerBin,
    "sellerRawContact": sellerRawContact,
    "sellerRawCountry": sellerRawCountry,
    "import": itemImport,
    "codeitem": codeitem,
    "rawSezon": rawSezon,
    "rawModel": rawModel,
    "rawComment": rawComment,
    "rawPerson": rawPerson,
    "rawSize": rawSize,
    "rawColor": rawColor,
    "rawExpiryDate": rawExpiryDate,
    "rawQuantity": rawQuantity,
    "rawUnit": rawUnit,
    "rawPurchaseprice": rawPurchaseprice,
    "rawSellingprice": rawSellingprice,
    "_id": id,
    "rawTotalPurchase": rawTotalPurchase,
    "rawTotalSelling": rawTotalSelling,
  };
}
