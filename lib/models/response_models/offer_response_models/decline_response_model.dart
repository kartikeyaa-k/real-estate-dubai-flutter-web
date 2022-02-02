class DeclineOfferResponseModel {
  bool success;

  DeclineOfferResponseModel({
    required this.success,
  });

  factory DeclineOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return DeclineOfferResponseModel(
      success: json['success'],
    );
  }
}
