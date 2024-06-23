class RawMaterial {
  String? bin;
  String? manufacturerIndustry;
  String item = "Сырье"; // по умолчанию Сырье
  String? itemRawName;
  String? itemType;
  String? selerBIN;
  String? selerRawContact;
  String? selerRawCountry;
  bool import = false; // по умолчанию false
  String? codeitem;
  String? rawSezon;
  String? rawModel;
  String? rawComment;
  String? rawPerson;
  String? rawSize;
  String? rawColor;
  DateTime? rawExpiryDate;
  int rawQuantity = 0; // по умолчанию 0
  String? rawUnit;
  int rawPurchaseprice = 0; // по умолчанию 0
  int? rawSellingprice;
  int? rawTotalPurchase;
  int? rawTotalSelling;

  RawMaterial({
    this.bin,
    this.manufacturerIndustry,
    required this.itemRawName,
    required this.itemType,
    this.selerBIN,
    this.selerRawContact,
    this.selerRawCountry,
    this.import = false,
    this.codeitem,
    this.rawSezon,
    required this.rawModel,
    this.rawComment,
    this.rawPerson,
    required this.rawSize,
    this.rawColor,
    this.rawExpiryDate,
    this.rawQuantity = 0,
    required this.rawUnit,
    this.rawPurchaseprice = 0,
    this.rawSellingprice,
    this.rawTotalPurchase,
    this.rawTotalSelling,
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      bin: json['bin'],
      manufacturerIndustry: json['manufacturerIndustry'],
      itemRawName: json['itemRawName'],
      itemType: json['itemType'],
      selerBIN: json['selerBIN'],
      selerRawContact: json['selerRawContact'],
      selerRawCountry: json['selerRawCountry'],
      import: json['import'] ?? false,
      codeitem: json['codeitem'],
      rawSezon: json['rawSezon'],
      rawModel: json['rawModel'],
      rawComment: json['rawComment'],
      rawPerson: json['rawPerson'],
      rawSize: json['rawSize'],
      rawColor: json['rawColor'],
      rawExpiryDate: json['rawExpiryDate'] != null ? DateTime.parse(json['rawExpiryDate']) : null,
      rawQuantity: json['rawQuantity'] ?? 0,
      rawUnit: json['rawUnit'],
      rawPurchaseprice: json['rawPurchaseprice'] ?? 0,
      rawSellingprice: json['rawSellingprice'],
      rawTotalPurchase: json['rawTotalPurchase'],
      rawTotalSelling: json['rawTotalSelling'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bin'] = this.bin;
    data['manufacturerIndustry'] = this.manufacturerIndustry;
    data['itemRawName'] = this.itemRawName;
    data['itemType'] = this.itemType;
    data['selerBIN'] = this.selerBIN;
    data['selerRawContact'] = this.selerRawContact;
    data['selerRawCountry'] = this.selerRawCountry;
    data['import'] = this.import;
    data['codeitem'] = this.codeitem;
    data['rawSezon'] = this.rawSezon;
    data['rawModel'] = this.rawModel;
    data['rawComment'] = this.rawComment;
    data['rawPerson'] = this.rawPerson;
    data['rawSize'] = this.rawSize;
    data['rawColor'] = this.rawColor;
    data['rawExpiryDate'] = this.rawExpiryDate?.toIso8601String();
    data['rawQuantity'] = this.rawQuantity;
    data['rawUnit'] = this.rawUnit;
    data['rawPurchaseprice'] = this.rawPurchaseprice;
    data['rawSellingprice'] = this.rawSellingprice;
    data['rawTotalPurchase'] = this.rawTotalPurchase;
    data['rawTotalSelling'] = this.rawTotalSelling;
    return data;
  }
}
