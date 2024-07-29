// To parse this JSON data, do
//
//     final registerModal = registerModalFromJson(jsonString);

import 'dart:convert';

List<RegisterModal> registerModalFromJson(String str) => List<RegisterModal>.from(json.decode(str).map((x) => RegisterModal.fromJson(x)));

String registerModalToJson(List<RegisterModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegisterModal {
    String id;
    String bin;
    String manufacturerName;
    String manufacturerCountry;
    String manufacturerAdress;
    String manufacturerContact;
    String manufacturerIndustry;
    String manufacturerEmail;
    String manufacturerInfo;
    String manufacturerLogo;
    List<RegisterModalUser> users;
    int v;

    RegisterModal({
        required this.id,
        required this.bin,
        required this.manufacturerName,
        required this.manufacturerCountry,
        required this.manufacturerAdress,
        required this.manufacturerContact,
        required this.manufacturerIndustry,
        required this.manufacturerEmail,
        required this.manufacturerInfo,
        required this.manufacturerLogo,
        required this.users,
        required this.v,
    });

    factory RegisterModal.fromJson(Map<String, dynamic> json) => RegisterModal(
        id: json["_id"],
        bin: json["bin"],
        manufacturerName: json["manufacturerName"],
        manufacturerCountry: json["manufacturerCountry"],
        manufacturerAdress: json["manufacturerAdress"],
        manufacturerContact: json["manufacturerContact"],
        manufacturerIndustry: json["manufacturerIndustry"],
        manufacturerEmail: json["manufacturerEmail"],
        manufacturerInfo: json["manufacturerInfo"],
        manufacturerLogo: json["manufacturerLogo"],
        users: List<RegisterModalUser>.from(json["users"].map((x) => RegisterModalUser.fromJson(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bin": bin,
        "manufacturerName": manufacturerName,
        "manufacturerCountry": manufacturerCountry,
        "manufacturerAdress": manufacturerAdress,
        "manufacturerContact": manufacturerContact,
        "manufacturerIndustry": manufacturerIndustry,
        "manufacturerEmail": manufacturerEmail,
        "manufacturerInfo": manufacturerInfo,
        "manufacturerLogo": manufacturerLogo,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "__v": v,
    };
}

class RegisterModalUser {
    String roleUser;
    List<UserUser> user;
    String id;

    RegisterModalUser({
        required this.roleUser,
        required this.user,
        required this.id,
    });

    factory RegisterModalUser.fromJson(Map<String, dynamic> json) => RegisterModalUser(
        roleUser: json["roleUser"],
        user: List<UserUser>.from(json["user"].map((x) => UserUser.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "roleUser": roleUser,
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
        "_id": id,
    };
}

class UserUser {
    String fio;
    String iin;
    DateTime dateOfBirth;
    String phone;
    String login;
    String avatar;
    String password;
    String id;

    UserUser({
        required this.fio,
        required this.iin,
        required this.dateOfBirth,
        required this.phone,
        required this.login,
        required this.avatar,
        required this.password,
        required this.id,
    });

    factory UserUser.fromJson(Map<String, dynamic> json) => UserUser(
        fio: json["fio"],
        iin: json["iin"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        phone: json["phone"],
        login: json["login"],
        avatar: json["avatar"],
        password: json["password"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "fio": fio,
        "iin": iin,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "phone": phone,
        "login": login,
        "avatar": avatar,
        "password": password,
        "_id": id,
    };
}
