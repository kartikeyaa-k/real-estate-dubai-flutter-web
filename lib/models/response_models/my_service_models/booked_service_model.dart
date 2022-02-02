import 'dart:convert';

BookedMyServiceModel bookedMyServiceFromJson(String str) => BookedMyServiceModel.fromJson(json.decode(str));

String bookedMyServiceToJson(BookedMyServiceModel data) => json.encode(data.toJson());

class BookedMyServiceModel {
  BookedMyServiceModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<BookedServiceModel> data;

  factory BookedMyServiceModel.fromJson(Map<String, dynamic> json) => BookedMyServiceModel(
        success: json["success"],
        data: List<BookedServiceModel>.from(json["data"].map((x) => BookedServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BookedServiceModel {
  BookedServiceModel({
    required this.id,
    required this.serviceRequestId,
    required this.serviceName,
    required this.description,
    required this.imageLink,
    required this.quotation,
    required this.scheduledDate,
    required this.fromTime,
    required this.toTime,
  });

  final int id;
  final int serviceRequestId;
  final String serviceName;
  final String description;
  final String imageLink;
  final String quotation;
  final DateTime? scheduledDate;
  final String fromTime;
  final String toTime;

  factory BookedServiceModel.fromJson(Map<String, dynamic> json) => BookedServiceModel(
        id: json["id"],
        serviceRequestId: json["service_request_id"],
        serviceName: json["service_name"],
        description: json["description"],
        imageLink: json["image_link"],
        quotation: json["quotation"],
        scheduledDate: json["scheduled_date"] != null ? DateTime.parse(json["scheduled_date"]) : null,
        fromTime: json["from_time"],
        toTime: json["to_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_request_id": serviceRequestId,
        "service_name": serviceName,
        "description": description,
        "image_link": imageLink,
        "quotation": quotation,
        "scheduled_date": scheduledDate?.toIso8601String(),
        "from_time": fromTime,
        "to_time": toTime,
      };
}
