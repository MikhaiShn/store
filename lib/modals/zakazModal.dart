class GetZakaz {
  String? sId;
  String? bin;
  String? manufacturerIndustry;
  String? binPokupatel;
  String? namePokupatel;
  String? contactPokupatel;
  int? zakazID;
  String? zakazModel;
  String? zakazSize;
  String? zakazColor;
  String? zakazComment;
  int? zakazQuantity;
  String? zakazUnit;
  num? zakazSellingprice; // Используйте num вместо int
  num? zakazTotalSelling; // Используйте num вместо int
  String? status;

  GetZakaz(
      {this.sId,
      this.bin,
      this.manufacturerIndustry,
      this.binPokupatel,
      this.namePokupatel,
      this.contactPokupatel,
      this.zakazID,
      this.zakazModel,
      this.zakazSize,
      this.zakazColor,
      this.zakazComment,
      this.zakazQuantity,
      this.zakazUnit,
      this.zakazSellingprice,
      this.zakazTotalSelling,
      this.status});

  GetZakaz.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bin = json['bin'];
    manufacturerIndustry = json['manufacturerIndustry'];
    binPokupatel = json['binPokupatel'];
    namePokupatel = json['namePokupatel'];
    contactPokupatel = json['contactPokupatel'];
    zakazID = json['zakazID'];
    zakazModel = json['zakazModel'];
    zakazSize = json['zakazSize'];
    zakazColor = json['zakazColor'];
    zakazComment = json['zakazComment'];
    zakazQuantity = json['zakazQuantity'];
    zakazUnit = json['zakazUnit'];
    zakazSellingprice = json['zakazSellingprice']; // Измените на num
    zakazTotalSelling = json['zakazTotalSelling']; // Измените на num
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['bin'] = this.bin;
    data['manufacturerIndustry'] = this.manufacturerIndustry;
    data['binPokupatel'] = this.binPokupatel;
    data['namePokupatel'] = this.namePokupatel;
    data['contactPokupatel'] = this.contactPokupatel;
    data['zakazID'] = this.zakazID;
    data['zakazModel'] = this.zakazModel;
    data['zakazSize'] = this.zakazSize;
    data['zakazColor'] = this.zakazColor;
    data['zakazComment'] = this.zakazComment;
    data['zakazQuantity'] = this.zakazQuantity;
    data['zakazUnit'] = this.zakazUnit;
    data['zakazSellingprice'] = this.zakazSellingprice; // Измените на num
    data['zakazTotalSelling'] = this.zakazTotalSelling; // Измените на num
    data['status'] = this.status;
    return data;
  }
}
