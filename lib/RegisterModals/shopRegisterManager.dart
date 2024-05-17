class StoreRegisterManager {
  String? bIN;
  String? companySelerManagerFIO;
  String? companySelerManagerIIN;
  String? companySelerManagerLogin;
  String? companySelerManagerPassword;
  String? role;

  StoreRegisterManager(
      {
      this.bIN,
      this.companySelerManagerFIO,
      this.companySelerManagerIIN,
      this.companySelerManagerLogin,
      this.companySelerManagerPassword,
      this.role,
      });

  StoreRegisterManager.fromJson(Map<String, dynamic> json) {
    bIN = json['BIN'];
    companySelerManagerFIO = json['CompanySelerManagerFIO'];
    companySelerManagerIIN = json['CompanySelerManagerIIN'];
    companySelerManagerLogin = json['CompanySelerManagerLogin'];
    companySelerManagerPassword = json['CompanySelerManagerPassword'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BIN'] = this.bIN;
    data['CompanySelerManagerFIO'] = this.companySelerManagerFIO;
    data['CompanySelerManagerIIN'] = this.companySelerManagerIIN;
    data['CompanySelerManagerLogin'] = this.companySelerManagerLogin;
    data['CompanySelerManagerPassword'] = this.companySelerManagerPassword;
    data['role'] = this.role;
    return data;
  }
}
