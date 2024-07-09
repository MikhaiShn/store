import 'dart:convert';

class TMZGroup {
  String id;
  String groupName;
  List<TMZModal> tmzList;

  TMZGroup({
    required this.id,
    required this.groupName,
    required this.tmzList,
  });

  factory TMZGroup.fromJson(Map<String, dynamic> json) => TMZGroup(
        id: json["_id"],
        groupName: json["groupName"],
        tmzList: List<TMZModal>.from(json["tmzList"].map((x) => TMZModal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "groupName": groupName,
        "tmzList": List<dynamic>.from(tmzList.map((x) => x.toJson())),
      };
}

List<TMZModal> tmzModalFromJson(String str) =>
    List<TMZModal>.from(json.decode(str).map((x) => TMZModal.fromJson(x)));

String tmzModalToJson(List<TMZModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class TMZModal {
  String id;
  String bin;
  String manufacturerIndustry;
  String item;
  Map<String, List<MaterialTmz>> materials;

  TMZModal({
    required this.id,
    required this.bin,
    required this.manufacturerIndustry,
    required this.item,
    required this.materials,
  });

  factory TMZModal.fromJson(Map<String, dynamic> json) => TMZModal(
    
        id: json["_id"],
        bin: json["bin"],
        manufacturerIndustry: json["manufacturerIndustry"],
        item: json["item"],
        materials: Map.from(json["materials"]).map((k, v) => MapEntry<String, List<MaterialTmz>>(
            k,
            List<MaterialTmz>.from(v.map((x) => MaterialTmz.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bin": bin,
        "manufacturerIndustry": manufacturerIndustry,
        "item": item,
        "materials": Map.from(materials).map((k, v) =>
            MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}


class MaterialTmz {
  String tmzId;
  String itemTmzName;
  String sellerBin;
  String sellerTmzContact;
  String sellerTmzCountry;
  bool materialImport;
  String codeitem;
  String tmzSezon;
  String tmzModel;
  String tmzComment;
  String tmzPerson;
  String tmzSize;
  String tmzColor;
  DateTime tmzExpiryDate;
  int tmzQuantity;
  String tmzUnit;
  int tmzPurchaseprice;
  int tmzSellingprice;
  int tmzTotalPurchase;
  int tmzTotalSelling;
  String id;

  MaterialTmz({
    required this.tmzId,
    required this.itemTmzName,
    required this.sellerBin,
    required this.sellerTmzContact,
    required this.sellerTmzCountry,
    required this.materialImport,
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
    required this.tmzTotalPurchase,
    required this.tmzTotalSelling,
    required this.id,
  });

  factory MaterialTmz.fromJson(Map<String, dynamic> json) => MaterialTmz(
        tmzId: json["tmzID"] ?? "",
        itemTmzName: json["itemTmzName"] ?? "",
        sellerBin: json["sellerBIN"] ?? "",
        sellerTmzContact: json["sellerTMZContact"] ?? "",
        sellerTmzCountry: json["sellerTMZCountry"] ?? "",
        materialImport: json["import"] ?? false,
        codeitem: json["codeitem"] ?? "",
        tmzSezon: json["tmzSezon"] ?? "",
        tmzModel: json["tmzModel"] ?? "",
        tmzComment: json["tmzComment"] ?? "",
        tmzPerson: json["tmzPerson"] ?? "",
        tmzSize: json["tmzSize"] ?? "",
        tmzColor: json["tmzColor"] ?? "",
        tmzExpiryDate: DateTime.parse(json["tmzExpiryDate"]),
        tmzQuantity: json["tmzQuantity"] ?? 0,
        tmzUnit: json["tmzUnit"] ?? "",
        tmzPurchaseprice: json["tmzPurchaseprice"] ?? 0,
        tmzSellingprice: json["tmzSellingprice"] ?? 0,
        tmzTotalPurchase: json["tmzTotalPurchase"] ?? 0,
        tmzTotalSelling: json["tmzTotalSelling"] ?? 0,
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "tmzID": tmzId,
        "itemTmzName": itemTmzName,
        "sellerBIN": sellerBin,
        "sellerTMZContact": sellerTmzContact,
        "sellerTMZCountry": sellerTmzCountry,
        "import": materialImport,
        "codeitem": codeitem,
        "tmzSezon": tmzSezon,
        "tmzModel": tmzModel,
        "tmzComment": tmzComment,
        "tmzPerson": tmzPerson,
        "tmzSize": tmzSize,
        "tmzColor": tmzColor,
        "tmzExpiryDate": tmzExpiryDate.toIso8601String(),
        "tmzQuantity": tmzQuantity,
        "tmzUnit": tmzUnit,
        "tmzPurchaseprice": tmzPurchaseprice,
        "tmzSellingprice": tmzSellingprice,
        "tmzTotalPurchase": tmzTotalPurchase,
        "tmzTotalSelling": tmzTotalSelling,
        "_id": id,
      };
}


