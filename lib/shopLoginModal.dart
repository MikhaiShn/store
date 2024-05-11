class StoreRegister {
  String? bIN;
  String? manufacturerName;
  String? manufacturerCountry;
  String? manufacturerAdress;
  String? manufacturerContact;
  String? manufacturerIndustry;
  String? manufacturerEmail;
  String? manufacturerInfo;
  String? manufacturerLogo;

  StoreRegister(
      {this.bIN,
      this.manufacturerName,
      this.manufacturerCountry,
      this.manufacturerAdress,
      this.manufacturerContact,
      this.manufacturerIndustry,
      this.manufacturerEmail,
      this.manufacturerInfo,
      this.manufacturerLogo});

  StoreRegister.fromJson(Map<String, dynamic> json) {
    bIN = json['BIN'];
    manufacturerName = json['ManufacturerName'];
    manufacturerCountry = json['ManufacturerCountry'];
    manufacturerAdress = json['ManufacturerAdress'];
    manufacturerContact = json['ManufacturerContact'];
    manufacturerIndustry = json['ManufacturerIndustry'];
    manufacturerEmail = json['ManufacturerEmail'];
    manufacturerInfo = json['ManufacturerInfo'];
    manufacturerLogo = json['ManufacturerLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BIN'] = this.bIN;
    data['ManufacturerName'] = this.manufacturerName;
    data['ManufacturerCountry'] = this.manufacturerCountry;
    data['ManufacturerAdress'] = this.manufacturerAdress;
    data['ManufacturerContact'] = this.manufacturerContact;
    data['ManufacturerIndustry'] = this.manufacturerIndustry;
    data['ManufacturerEmail'] = this.manufacturerEmail;
    data['ManufacturerInfo'] = this.manufacturerInfo;
    data['ManufacturerLogo'] = this.manufacturerLogo;
    return data;
  }
}
