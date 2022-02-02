class NewRequestedServiceRequestParams {
  String serviceName;
  String serviceType;

  NewRequestedServiceRequestParams({required this.serviceName, required this.serviceType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_name'] = this.serviceName;
    data['service_type'] = this.serviceType;
    return data;
  }
}
