class BookStatusRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  int property_id;

  // ignore: non_constant_identifier_names
  BookStatusRequestParams({required this.property_id});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['property_id'] = property_id;
    return map;
  }
}
