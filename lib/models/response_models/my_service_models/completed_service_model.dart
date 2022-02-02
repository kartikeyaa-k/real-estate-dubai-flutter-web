import 'dart:convert';

CompletedMyServiceModel completedMyServiceFromJson(String str) => CompletedMyServiceModel.fromJson(json.decode(str));

String completedMyServiceToJson(CompletedMyServiceModel data) => json.encode(data.toJson());

class CompletedMyServiceModel {
  CompletedMyServiceModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<CompletedServiceModel> data;

  factory CompletedMyServiceModel.fromJson(Map<String, dynamic> json) => CompletedMyServiceModel(
        success: json["success"],
        data: List<CompletedServiceModel>.from(json["data"].map((x) => CompletedServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CompletedServiceModel {
  CompletedServiceModel({
    required this.id,
    required this.serviceRequestId,
    required this.serviceName,
    required this.description,
    required this.imageLink,
    required this.isQuestionAnswered,
    required this.quotation,
  });

  final int id;
  final int serviceRequestId;
  final String serviceName;
  final String description;
  final String? imageLink;
  final bool isQuestionAnswered;
  final String quotation;

  factory CompletedServiceModel.fromJson(Map<String, dynamic> json) => CompletedServiceModel(
        id: json["id"],
        serviceRequestId: json["service_request_id"],
        serviceName: json["service_name"],
        description: json["description"],
        imageLink: json["image_link"] == null ? null : json["image_link"],
        isQuestionAnswered: json["is_question_answered"] == 1,
        quotation: json["quotation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_request_id": serviceRequestId,
        "service_name": serviceName,
        "description": description,
        "image_link": imageLink == null ? null : imageLink,
        "is_satisfied": isQuestionAnswered ? 1 : 0,
        "quotation": quotation,
      };
}
