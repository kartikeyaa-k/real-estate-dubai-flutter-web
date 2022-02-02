class VerificationStatusResponseModel {
  String? verificationUrl;
  String? verificationStatus;

  VerificationStatusResponseModel({this.verificationUrl, this.verificationStatus});

  VerificationStatusResponseModel.fromJson(Map<String, dynamic> json) {
    verificationUrl = json['verification_url'];
    verificationStatus = json['verification_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verification_url'] = this.verificationUrl;
    data['verification_status'] = this.verificationStatus;
    return data;
  }
}
