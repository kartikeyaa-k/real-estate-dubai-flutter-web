class AcceptOfferResponseModel {
  bool success;

  AcceptOfferResponseModel({
    required this.success,
  });

  factory AcceptOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptOfferResponseModel(
      success: json['success'],
    );
  }
}
