import 'dart:convert';

List<CalculateModal> calculateModalFromJson(String str) => List<CalculateModal>.from(json.decode(str).map((x) => CalculateModal.fromJson(x)));

String calculateModalToJson(List<CalculateModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CalculateModal {
    String id;
    String bin;
    String manufacturerIndustry;
    String comment;
    List<ItemModel> itemModels;
    int v;

    CalculateModal({
        required this.id,
        required this.bin,
        required this.manufacturerIndustry,
        required this.comment,
        required this.itemModels,
        required this.v,
    });

    factory CalculateModal.fromJson(Map<String, dynamic> json) => CalculateModal(
        id: json["_id"],
        bin: json["bin"],
        manufacturerIndustry: json["manufacturerIndustry"],
        comment: json["comment"],
        itemModels: List<ItemModel>.from(json["itemModels"].map((x) => ItemModel.fromJson(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bin": bin,
        "manufacturerIndustry": manufacturerIndustry,
        "comment": comment,
        "itemModels": List<dynamic>.from(itemModels.map((x) => x.toJson())),
        "__v": v,
    };
}

class ItemModel {
    String modelName;
    List<SizeVariation> sizeVariations;
    String id;

    ItemModel({
        required this.modelName,
        required this.sizeVariations,
        required this.id,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        modelName: json["modelName"],
        sizeVariations: List<SizeVariation>.from(json["sizeVariations"].map((x) => SizeVariation.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "modelName": modelName,
        "sizeVariations": List<dynamic>.from(sizeVariations.map((x) => x.toJson())),
        "_id": id,
    };
}

class SizeVariation {
    String size;
    List<dynamic> components;
    List<LaborCost> laborCosts;
    String id;

    SizeVariation({
        required this.size,
        required this.components,
        required this.laborCosts,
        required this.id,
    });

    factory SizeVariation.fromJson(Map<String, dynamic> json) => SizeVariation(
        size: json["size"],
        components: List<dynamic>.from(json["components"].map((x) => x)),
        laborCosts: List<LaborCost>.from(json["laborCosts"].map((x) => LaborCost.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "size": size,
        "components": List<dynamic>.from(components.map((x) => x)),
        "laborCosts": List<dynamic>.from(laborCosts.map((x) => x.toJson())),
        "_id": id,
    };
}

class LaborCost {
    String laborType;
    int cost;
    String id;

    LaborCost({
        required this.laborType,
        required this.cost,
        required this.id,
    });

    factory LaborCost.fromJson(Map<String, dynamic> json) => LaborCost(
        laborType: json["laborType"],
        cost: json["cost"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "laborType": laborType,
        "cost": cost,
        "_id": id,
    };
}
