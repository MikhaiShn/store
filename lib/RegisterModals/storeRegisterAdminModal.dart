class StoreRegisterAdmin {
  String? bIN;
  String? companySelerAdminFIO;
  String? companySelerAdminIIN;
  String? companySelerAdminLogin;
  String? companySelerAdminPassword;
  String? role;

  StoreRegisterAdmin({
    this.bIN,
    this.companySelerAdminFIO,
    this.companySelerAdminIIN,
    this.companySelerAdminLogin,
    this.companySelerAdminPassword,
    this.role,
  });

  StoreRegisterAdmin.fromJson(Map<String, dynamic> json) {
    bIN = json['BIN'];
    companySelerAdminFIO = json['CompanySelerAdminFIO'];
    companySelerAdminIIN = json['CompanySelerAdminIIN'];
    companySelerAdminLogin = json['CompanySelerAdminLogin'];
    companySelerAdminPassword = json['CompanySelerAdminPassword'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BIN'] = this.bIN;
    data['CompanySelerAdminFIO'] = this.companySelerAdminFIO;
    data['CompanySelerAdminIIN'] = this.companySelerAdminIIN;
    data['CompanySelerAdminLogin'] = this.companySelerAdminLogin;
    data['CompanySelerAdminPassword'] = this.companySelerAdminPassword;
    data['role'] = this.role;
    return data;
  }
}
