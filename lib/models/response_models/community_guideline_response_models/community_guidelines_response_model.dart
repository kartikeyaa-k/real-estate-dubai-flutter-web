import 'emirates_model.dart';

class CommunityGuidelinesResponseModel {
  List<EmiratesModel>? result;

  CommunityGuidelinesResponseModel({this.result});

  factory CommunityGuidelinesResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityGuidelinesResponseModel(
        result: json['result'] != null
            ? List<EmiratesModel>.from((json['result'] as List<dynamic>).map((e) => EmiratesModel.fromJson(e)))
            : null);
  }
}
