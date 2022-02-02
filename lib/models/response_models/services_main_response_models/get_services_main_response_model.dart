class GetServicesMainResponseModel {
  bool status;
  List<ServiceMainModel> result;

  GetServicesMainResponseModel({required this.status, required this.result});

  factory GetServicesMainResponseModel.fromJson(Map<String, dynamic> json) {
    return GetServicesMainResponseModel(
      status: json['status'],
      result: json['result'] != null
          ? List<ServiceMainModel>.from((json['result'] as List<dynamic>).map((e) => ServiceMainModel.fromJson(e)))
          : [],
    );
  }
}

class ServiceMainModel {
  int id;
  String serviceName;
  String? serviceDescription;
  List<String> images;

  ServiceMainModel({required this.id, required this.serviceName, this.serviceDescription, required this.images});

  factory ServiceMainModel.fromJson(Map<String, dynamic> json) {
    return ServiceMainModel(
        id: json['id'],
        serviceName: json['service_name'],
        serviceDescription: json['service_description'] ?? "",
        images: json['images'].cast<String>());
  }
}
