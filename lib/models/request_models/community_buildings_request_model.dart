class CommunityBuildingRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  int community_id;
  int limit;
  int offset;

  // ignore: non_constant_identifier_names
  CommunityBuildingRequestParams({required this.community_id, this.limit = 10, this.offset = 0});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['community_id'] = community_id;
    map['limit'] = limit;
    map['offset'] = offset;
    return map;
  }
}
