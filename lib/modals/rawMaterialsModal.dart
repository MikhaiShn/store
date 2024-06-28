import 'dart:convert';

List<Manufacturer> rawMaterialsModalFromJson(String str) => List<Manufacturer>.from(json.decode(str).map((x) => Manufacturer.fromJson(x)));

String rawMaterialsModalToJson(List<Manufacturer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Manufacturer {
    String id;
    String bin;
    String manufacturerIndustry;
    String item;
    Map<String, List<RawMaterial>> materials;

    Manufacturer({
        required this.id,
        required this.bin,
        required this.manufacturerIndustry,
        required this.item,
        required this.materials,
    });

    factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
        id: json["_id"],
        bin: json["bin"],
        manufacturerIndustry: json["manufacturerIndustry"],
        item: json["item"],
        materials: Map.from(json["materials"]).map((k, v) => MapEntry<String, List<RawMaterial>>(k, List<RawMaterial>.from(v.map((x) => RawMaterial.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bin": bin,
        "manufacturerIndustry": manufacturerIndustry,
        "item": item,
        "materials": Map.from(materials).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    };
}

class RawMaterial {
    String id;
    String itemRawName;
    String selerBin;
    String selerRawContact;
    String selerRawCountry;
    bool materialImport;
    String codeitem;
    String rawSezon;
    String rawModel;
    String rawComment;
    String rawPerson;
    String rawSize;
    String rawColor;
    DateTime rawExpiryDate;
    int rawQuantity;
    String rawUnit;
    int rawPurchasePrice;
    int rawSellingPrice;
    int rawTotalPurchase;
    int rawTotalSelling;
    String rawId;

    RawMaterial({
        required this.id,
        required this.itemRawName,
        required this.selerBin,
        required this.selerRawContact,
        required this.selerRawCountry,
        required this.materialImport,
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
        required this.rawPurchasePrice,
        required this.rawSellingPrice,
        required this.rawTotalPurchase,
        required this.rawTotalSelling,
        required this.rawId,
    });

factory RawMaterial.fromJson(Map<String, dynamic> json) {
  return RawMaterial(
    id: json['_id'] ?? '',
    itemRawName: json['itemRawName'] ?? '',
    selerBin: json['selerBIN'] ?? '',
    selerRawContact: json['selerRawContact'] ?? '',
    selerRawCountry: json['selerRawCountry'] ?? '',
    materialImport: json['import'] ?? false,
    codeitem: json['codeitem'] ?? '',
    rawSezon: json['rawSezon'] ?? '',
    rawModel: json['rawModel'] ?? '',
    rawComment: json['rawComment'] ?? '',
    rawPerson: json['rawPerson'] ?? '',
    rawSize: json['rawSize'] ?? '',
    rawColor: json['rawColor'] ?? '',
    rawExpiryDate: json['rawExpiryDate'] != null ? DateTime.parse(json['rawExpiryDate']) : DateTime.now(),
    rawQuantity: json['rawQuantity'] ?? 0,
    rawUnit: json['rawUnit'] ?? '',
    rawPurchasePrice: json['rawPurchaseprice'] ?? 0,
    rawSellingPrice: json['rawSellingprice'] ?? 0,
    rawTotalPurchase: json['rawTotalPurchase'] ?? 0,
    rawTotalSelling: json['rawTotalSelling'] ?? 0,
    rawId: json['rawID'] ?? '',
  );
}


    Map<String, dynamic> toJson() => {
        "_id": id,
        "itemRawName": itemRawName,
        "selerBIN": selerBin,
        "selerRawContact": selerRawContact,
        "selerRawCountry": selerRawCountry,
        "import": materialImport,
        "codeitem": codeitem,
        "rawSezon": rawSezon,
        "rawModel": rawModel,
        "rawComment": rawComment,
        "rawPerson": rawPerson,
        "rawSize": rawSize,
        "rawColor": rawColor,
        "rawExpiryDate": rawExpiryDate.toIso8601String(),
        "rawQuantity": rawQuantity,
        "rawUnit": rawUnit,
        "rawPurchaseprice": rawPurchasePrice,
        "rawSellingprice": rawSellingPrice,
        "rawTotalPurchase": rawTotalPurchase,
        "rawTotalSelling": rawTotalSelling,
        "rawID": rawId,
    };
}