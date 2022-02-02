import 'dart:convert';

QuotedMyServiceModel quotedMyServiceFromJson(String str) => QuotedMyServiceModel.fromJson(json.decode(str));

String quotedMyServiceToJson(QuotedMyServiceModel data) => json.encode(data.toJson());

class QuotedMyServiceModel {
  QuotedMyServiceModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<QuotedServiceModel> data;

  factory QuotedMyServiceModel.fromJson(Map<String, dynamic> json) => QuotedMyServiceModel(
        success: json["success"],
        data: List<QuotedServiceModel>.from(json["data"].map((x) => QuotedServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class QuotedServiceModel {
  QuotedServiceModel({
    required this.id,
    required this.serviceRequestId,
    required this.serviceName,
    required this.description,
    required this.imageLink,
    required this.quotation,
  });

  final int id;
  final int serviceRequestId;
  final String serviceName;
  final String description;
  final String? imageLink;
  final String quotation;

  factory QuotedServiceModel.fromJson(Map<String, dynamic> json) => QuotedServiceModel(
        id: json["id"],
        serviceRequestId: json["service_request_id"],
        serviceName: json["service_name"],
        description: json["description"],
        imageLink: json["image_link"] != null ? json["image_link"] : null,
        quotation: json["quotation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_request_id": serviceRequestId,
        "service_name": serviceName,
        "description": description,
        "image_link": imageLink,
        "quotation": quotation,
      };
}
