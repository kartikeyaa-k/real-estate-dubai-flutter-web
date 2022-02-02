class AddServiceAgencyResponseModel {
  bool status;
  AddServiceAgencyResponseModel({required this.status});
  factory AddServiceAgencyResponseModel.fromJson(Map<String, dynamic> json) {
    return AddServiceAgencyResponseModel(status: json['status']);
  }
}
