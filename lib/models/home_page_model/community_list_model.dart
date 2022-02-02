import 'dart:convert';

import 'package:equatable/equatable.dart';

CommunityListModel communityListModelFromJson(String str) => CommunityListModel.fromJson(json.decode(str));

String communityListModelToJson(CommunityListModel data) => json.encode(data.toJson());

class CommunityListModel extends Equatable {
  const CommunityListModel({
    required this.success,
    required this.communityList,
    required this.total,
  });

  final bool success;
  final List<CommunityModel> communityList;
  final int total;

  static const empty = CommunityListModel(success: false, communityList: [], total: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory CommunityListModel.fromJson(Map<String, dynamic> json) => CommunityListModel(
        success: json["success"],
        communityList: List<CommunityModel>.from(json["communityList"].map((x) => CommunityModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "communityList": List<dynamic>.from(communityList.map((x) => x.toJson())),
        "total": total,
      };

  @override
  List<Object?> get props => [success, communityList, total];
}

class CommunityModel extends Equatable {
  const CommunityModel({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String image;

  static const empty = CommunityModel(id: 0, name: "", image: "");
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };

  @override
  List<Object> get props => [id, name, image];
}
