class SubmitEnquiryResponseModel {
  bool success;

  SubmitEnquiryResponseModel({required this.success});

  factory SubmitEnquiryResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitEnquiryResponseModel(
      success: json['success'],
    );
  }
}
