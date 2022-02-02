import 'package:real_estate_portal/models/response_models/community_guideline_response_models/review_model.dart';

class CommunityDetailModel {
  int id;
  double latitude;
  double longitude;
  String image;
  String emirateName;
  String communityName;
  String description;
  ReviewModel reviewData;

  CommunityDetailModel(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.image,
      required this.emirateName,
      required this.communityName,
      required this.description,
      required this.reviewData});

  factory CommunityDetailModel.fromJson(Map<String, dynamic> json) {
    return CommunityDetailModel(
        id: json['id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        image: json['image'],
        emirateName: json['emirate_name'],
        communityName: json['community_name'],
        description: json['description'],
        reviewData: ReviewModel.fromJson(json['review_data']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['image'] = this.image;
    data['emirate_name'] = this.emirateName;
    data['community_name'] = this.communityName;
    data['description'] = this.description;
    if (this.reviewData != null) {
      data['review_data'] = this.reviewData.toJson();
    }
    return data;
  }
}
