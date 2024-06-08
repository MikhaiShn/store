class GetZakaz {
  String? status;
  String? sId;
  String? bin;
  String? manufacturerIndustry;
  int? zakazID;
  String? zakazModel;
  String? zakazSize;
  String? zakazColor;
  String? zakazComment;
  int? zakazQuantity;
  String? zakazUnit;
  int? zakazSellingprice;
  int? zakazTotalSelling;
  int? iV;

  GetZakaz(
      {this.status,
      this.sId,
      this.bin,
      this.manufacturerIndustry,
      this.zakazID,
      this.zakazModel,
      this.zakazSize,
      this.zakazColor,
      this.zakazComment,
      this.zakazQuantity,
      this.zakazUnit,
      this.zakazSellingprice,
      this.zakazTotalSelling,
      this.iV});

  GetZakaz.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sId = json['_id'];
    bin = json['bin'];
    manufacturerIndustry = json['manufacturerIndustry'];
    zakazID = json['zakazID'];
    zakazModel = json['zakazModel'];
    zakazSize = json['zakazSize'];
    zakazColor = json['zakazColor'];
    zakazComment = json['zakazComment'];
    zakazQuantity = json['zakazQuantity'];
    zakazUnit = json['zakazUnit'];
    zakazSellingprice = json['zakazSellingprice'];
    zakazTotalSelling = json['zakazTotalSelling'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['bin'] = this.bin;
    data['manufacturerIndustry'] = this.manufacturerIndustry;
    data['zakazID'] = this.zakazID;
    data['zakazModel'] = this.zakazModel;
    data['zakazSize'] = this.zakazSize;
    data['zakazColor'] = this.zakazColor;
    data['zakazComment'] = this.zakazComment;
    data['zakazQuantity'] = this.zakazQuantity;
    data['zakazUnit'] = this.zakazUnit;
    data['zakazSellingprice'] = this.zakazSellingprice;
    data['zakazTotalSelling'] = this.zakazTotalSelling;
    data['__v'] = this.iV;
    return data;
  }
}
