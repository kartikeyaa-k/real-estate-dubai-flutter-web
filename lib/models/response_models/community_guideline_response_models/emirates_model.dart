import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_model.dart';

class EmiratesModel {
  int id;
  String image;
  String emirateName;
  String description;
  List<CommunityModel> communities;

  EmiratesModel(
      {required this.id, required this.image, required this.emirateName, required this.description, required this.communities});

  factory EmiratesModel.fromJson(Map<String, dynamic> json) {
    return EmiratesModel(
        id: json['id'],
        image: json['image'],
        emirateName: json['emirate_name'],
        description: json['description'],
        communities: json['communities'] != null
            ? List<CommunityModel>.from(
                (json['communities'] as List<dynamic>).map((e) => CommunityModel.fromJson(e as Map<String, dynamic>)))
            : []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['emirate_name'] = this.emirateName;
    data['description'] = this.description;
    if (this.communities != null) {
      data['communities'] = this.communities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
