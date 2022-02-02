import 'community_detail_model.dart';

class CommunityDetailResponseModel {
  CommunityDetailModel result;

  CommunityDetailResponseModel({required this.result});

  factory CommunityDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityDetailResponseModel(result: CommunityDetailModel.fromJson(json['result']));
  }
}
