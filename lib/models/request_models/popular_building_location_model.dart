class PopularBuildingLocationRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  int community_id;

  // ignore: non_constant_identifier_names
  PopularBuildingLocationRequestParams({required this.community_id});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['community_id'] = community_id;
    return map;
  }
}
