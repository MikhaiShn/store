class GetProduct {
  String? sId;
  String? bin;
  String? manufacturerIndustry;
  String? item;
  String? productName;
  String? productType;
  String? codeitem;
  String? productSezon;
  String? productModel;
  String? productComment;
  String? productPerson;
  String? productSize;
  String? productColor;
  int? productQuantity;
  String? productUnit;
  int? productSebeStoimost;
  int? productSellingprice;
  int? productTotalSebestoimost;
  int? productTotalSelling;
  int? iV;

  GetProduct(
      {this.sId,
      this.bin,
      this.manufacturerIndustry,
      this.item,
      this.productName,
      this.productType,
      this.codeitem,
      this.productSezon,
      this.productModel,
      this.productComment,
      this.productPerson,
      this.productSize,
      this.productColor,
      this.productQuantity,
      this.productUnit,
      this.productSebeStoimost,
      this.productSellingprice,
      this.productTotalSebestoimost,
      this.productTotalSelling,
      this.iV});

  GetProduct.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bin = json['bin'];
    manufacturerIndustry = json['manufacturerIndustry'];
    item = json['item'];
    productName = json['productName'];
    productType = json['productType'];
    codeitem = json['codeitem'];
    productSezon = json['productSezon'];
    productModel = json['productModel'];
    productComment = json['productComment'];
    productPerson = json['productPerson'];
    productSize = json['productSize'];
    productColor = json['productColor'];
    productQuantity = json['productQuantity'];
    productUnit = json['productUnit'];
    productSebeStoimost = json['productSebeStoimost'];
    productSellingprice = json['productSellingprice'];
    productTotalSebestoimost = json['productTotalSebestoimost'];
    productTotalSelling = json['productTotalSelling'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['bin'] = this.bin;
    data['manufacturerIndustry'] = this.manufacturerIndustry;
    data['item'] = this.item;
    data['productName'] = this.productName;
    data['productType'] = this.productType;
    data['codeitem'] = this.codeitem;
    data['productSezon'] = this.productSezon;
    data['productModel'] = this.productModel;
    data['productComment'] = this.productComment;
    data['productPerson'] = this.productPerson;
    data['productSize'] = this.productSize;
    data['productColor'] = this.productColor;
    data['productQuantity'] = this.productQuantity;
    data['productUnit'] = this.productUnit;
    data['productSebeStoimost'] = this.productSebeStoimost;
    data['productSellingprice'] = this.productSellingprice;
    data['productTotalSebestoimost'] = this.productTotalSebestoimost;
    data['productTotalSelling'] = this.productTotalSelling;
    data['__v'] = this.iV;
    return data;
  }
}
