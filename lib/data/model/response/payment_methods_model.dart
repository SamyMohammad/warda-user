// To parse this JSON data, do
//
//     final paymentMethodsModel = paymentMethodsModelFromJson(jsonString);

import 'dart:convert';

PaymentMethodsModel paymentMethodsModelFromJson(String str) => PaymentMethodsModel.fromJson(json.decode(str));

String paymentMethodsModelToJson(PaymentMethodsModel data) => json.encode(data.toJson());

class PaymentMethodsModel {
    final String status;
    final List<PaymentMethod> paymentMethod;

    PaymentMethodsModel({
        required this.status,
        required this.paymentMethod,
    });

    factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) => PaymentMethodsModel(
        status: json["status"],
        paymentMethod: List<PaymentMethod>.from(json["data"].map((x) => PaymentMethod.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(paymentMethod.map((x) => x.toJson())),
    };
}

class PaymentMethod {
    final String key;
    final String icon;

    PaymentMethod({
        required this.key,
        required this.icon
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        key: json["key"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "icon":icon
    };
}
