class CommunityModel {
  int communityId;
  String communityName;
  String communityImage;

  CommunityModel({required this.communityId, required this.communityName, required this.communityImage});

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      communityId: json['community_id'],
      communityName: json['community_name'],
      communityImage: json['community_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['community_id'] = this.communityId;
    data['community_name'] = this.communityName;
    data['community_image'] = this.communityImage;
    return data;
  }
}
