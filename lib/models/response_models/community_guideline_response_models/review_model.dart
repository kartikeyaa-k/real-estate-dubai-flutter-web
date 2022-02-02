class ReviewModel {
  int totalReviewCount;
  String averageRating;

  ReviewModel({required this.totalReviewCount, required this.averageRating});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      totalReviewCount: json['total_review_count'],
      averageRating: json['average_rating'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_review_count'] = this.totalReviewCount;
    data['average_rating'] = this.averageRating;
    return data;
  }
}
