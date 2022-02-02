import 'package:real_estate_portal/models/response_models/service_list_models/service_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';

class ServiceListResponseModel {
  bool status;
  List<ServiceModel>? result;

  ServiceListResponseModel({required this.status, required this.result});

  factory ServiceListResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceListResponseModel(
        status: json['status'],
        result: json['result'] != null
            ? List<ServiceModel>.from(
                (json['result'] as List<dynamic>).map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)))
            : null);
  }
}
