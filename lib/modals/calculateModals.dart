// To parse this JSON data, do
//
//     final calculateModal = calculateModalFromJson(jsonString);

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
        id: json["_id"] ?? '',
        bin: json["bin"] ?? '',
        manufacturerIndustry: json["manufacturerIndustry"] ?? '',
        comment: json["comment"] ?? '',
        itemModels: List<ItemModel>.from(json["itemModels"].map((x) => ItemModel.fromJson(x))),
        v: json["__v"] ?? 0,
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
    int averagePrice;
    List<SizeVariation> sizeVariations;
    String id;

    ItemModel({
        required this.modelName,
        required this.averagePrice,
        required this.sizeVariations,
        required this.id,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        modelName: json["modelName"] ?? '',
        averagePrice: json["averagePrice"] ?? 0,
        sizeVariations: List<SizeVariation>.from(json["sizeVariations"].map((x) => SizeVariation.fromJson(x))),
        id: json["_id"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "modelName": modelName,
        "averagePrice": averagePrice,
        "sizeVariations": List<dynamic>.from(sizeVariations.map((x) => x.toJson())),
        "_id": id,
    };
}

class SizeVariation {
    String size;
    List<Component> components;
    List<LaborCost> laborCosts;
    String id;
    int costPrice;

    SizeVariation({
        required this.size,
        required this.components,
        required this.laborCosts,
        required this.id,
        required this.costPrice,
    });

    factory SizeVariation.fromJson(Map<String, dynamic> json) => SizeVariation(
        size: json["size"] ?? '',
        components: List<Component>.from(json["components"].map((x) => Component.fromJson(x))),
        laborCosts: List<LaborCost>.from(json["laborCosts"].map((x) => LaborCost.fromJson(x))),
        id: json["_id"] ?? '',
        costPrice: json["costPrice"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "size": size,
        "components": List<dynamic>.from(components.map((x) => x.toJson())),
        "laborCosts": List<dynamic>.from(laborCosts.map((x) => x.toJson())),
        "_id": id,
        "costPrice": costPrice,
    };
}

class Component {
    String componentType;
    String componentId;
    String componentName;
    bool componentImport;
    String model;
    String comment;
    String size;
    String color;
    String unit;
    int quantity;
    int purchaseprice;
    String id;

    Component({
        required this.componentType,
        required this.componentId,
        required this.componentName,
        required this.componentImport,
        required this.model,
        required this.comment,
        required this.size,
        required this.color,
        required this.unit,
        required this.quantity,
        required this.purchaseprice,
        required this.id,
    });

    factory Component.fromJson(Map<String, dynamic> json) => Component(
        componentType: json["componentType"] ?? '',
        componentId: json["componentID"] ?? '',
        componentName: json["componentName"] ?? '',
        componentImport: json["import"] ?? false,
        model: json["model"] ?? '',
        comment: json["comment"] ?? '',
        size: json["size"] ?? '',
        color: json["color"] ?? '',
        unit: json["unit"] ?? '',
        quantity: json["quantity"] ?? 0,
        purchaseprice: json["purchaseprice"] ?? 0,
        id: json["_id"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "componentType": componentType,
        "componentID": componentId,
        "componentName": componentName,
        "import": componentImport,
        "model": model,
        "comment": comment,
        "size": size,
        "color": color,
        "unit": unit,
        "quantity": quantity,
        "purchaseprice": purchaseprice,
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
        laborType: json["laborType"] ?? '',
        cost: json["cost"] ?? 0,
        id: json["_id"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "laborType": laborType,
        "cost": cost,
        "_id": id,
    };
}
