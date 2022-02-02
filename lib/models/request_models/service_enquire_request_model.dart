class ServiceEnquireRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  String interested_in, property_type, service_name, address;

  // ignore: non_constant_identifier_names
  ServiceEnquireRequestParams(
      {required this.interested_in, required this.address, required this.property_type, required this.service_name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['interested_in'] = interested_in;
    map['property_type'] = property_type;
    map['service_name'] = service_name;
    map['address'] = address;
    return map;
  }
}
