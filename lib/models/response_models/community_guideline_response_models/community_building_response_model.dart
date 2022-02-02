import 'community_building_model.dart';

class CommunityBuildingResponseModel {
  List<CommunityBuildingModel>? result;
  int total;

  CommunityBuildingResponseModel({this.result, required this.total});

  factory CommunityBuildingResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityBuildingResponseModel(
        result: json['result'] != null
            ? List<CommunityBuildingModel>.from((json['result'] as List<dynamic>).map((e) => CommunityBuildingModel.fromJson(e)))
            : null,
        total: json['total']);
  }
}
