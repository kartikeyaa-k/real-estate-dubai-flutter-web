class ServiceListRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  String service_type;

  // ignore: non_constant_identifier_names
  ServiceListRequestParams({required this.service_type});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['service_type'] = service_type;
    return map;
  }
}
