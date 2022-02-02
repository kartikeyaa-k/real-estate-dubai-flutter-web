import 'package:real_estate_portal/models/response_models/service_list_models/service_name_model.dart';

class ServiceModel {
  int service_id;
  ServiceNameModel? service_name;

  ServiceModel({required this.service_id, required this.service_name});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      service_id: json['service_id'],
      service_name: ServiceNameModel.fromJson(json['service_name']),
    );
  }
}
