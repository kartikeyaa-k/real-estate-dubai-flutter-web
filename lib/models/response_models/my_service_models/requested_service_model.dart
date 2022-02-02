import 'dart:convert';

RequestedMyServiceModel requestedMyServiceModelFromJson(String str) =>
    RequestedMyServiceModel.fromJson(json.decode(str));

String requestedMyServiceModelToJson(RequestedMyServiceModel data) => json.encode(data.toJson());

class RequestedMyServiceModel {
  RequestedMyServiceModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<RequestedServiceModel> data;

  factory RequestedMyServiceModel.fromJson(Map<String, dynamic> json) => RequestedMyServiceModel(
        success: json["success"],
        data: List<RequestedServiceModel>.from(json["data"].map((x) => RequestedServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RequestedServiceModel {
  RequestedServiceModel({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.imageLink,
  });

  final int id;
  final String serviceName;
  final String description;
  final String? imageLink;

  factory RequestedServiceModel.fromJson(Map<String, dynamic> json) => RequestedServiceModel(
        id: json["id"],
        serviceName: json["service_name"],
        description: json["description"],
        imageLink: json["image_link"] != null ? json["image_link"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_name": serviceName,
        "description": description,
        "image_link": imageLink,
      };
}
