class CommunityBuildingModel {
  int id;
  String buildingName;
  String image;
  int totalReviewCount;
  String averageRating;

  CommunityBuildingModel(
      {required this.id,
      required this.buildingName,
      required this.image,
      required this.totalReviewCount,
      required this.averageRating});

  factory CommunityBuildingModel.fromJson(Map<String, dynamic> json) {
    return CommunityBuildingModel(
        id: json['id'],
        buildingName: json['building_name'],
        image: json['image'],
        totalReviewCount: json['total_review_count'],
        averageRating: json['average_rating']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['building_name'] = this.buildingName;
    data['image'] = this.image;
    data['total_review_count'] = this.totalReviewCount;
    data['average_rating'] = this.averageRating;
    return data;
  }
}
