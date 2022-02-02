import 'dart:convert';

import 'package:equatable/equatable.dart';

HomeProjectListModel projectListModelFromJson(String str) => HomeProjectListModel.fromJson(json.decode(str));

class ProjectListModelEnumConverter {
  static const statusValues = EnumValues(
      {"Under Construction": ConstructionStatus.UNDER_CONSTRUCTION, "Complete": ConstructionStatus.COMPLETE});
}

String projectListModelToJson(HomeProjectListModel data) => json.encode(data.toJson());

enum ConstructionStatus { UNDER_CONSTRUCTION, COMPLETE }

class HomeProjectListModel extends Equatable {
  const HomeProjectListModel({
    required this.success,
    required this.projectList,
    required this.total,
  });

  final bool success;
  final List<HomeProjectModel> projectList;
  final int total;

  static const empty = HomeProjectListModel(success: false, projectList: [], total: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory HomeProjectListModel.fromJson(Map<String, dynamic> json) => HomeProjectListModel(
        success: json["success"],
        projectList: List<HomeProjectModel>.from(json["projectList"].map((x) => HomeProjectModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "projectList": List<dynamic>.from(projectList.map((x) => x.toJson())),
        "total": total,
      };

  @override
  List<Object> get props => [success, projectList, total];
}

class HomeProjectModel extends Equatable {
  const HomeProjectModel({
    required this.id,
    required this.name,
    required this.status,
    required this.totalUnits,
    required this.address,
    required this.isVerified,
    required this.pricePerSqFeet,
    required this.imageLink,
  });

  final int id;
  final String name;
  final ConstructionStatus status;
  final int totalUnits;
  final String address;
  final bool isVerified;
  final int? pricePerSqFeet;
  final dynamic imageLink;

  static const empty = HomeProjectModel(
      id: 0,
      name: "",
      status: ConstructionStatus.UNDER_CONSTRUCTION,
      totalUnits: 0,
      address: "",
      isVerified: false,
      pricePerSqFeet: 0,
      imageLink: "");
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory HomeProjectModel.fromJson(Map<String, dynamic> json) => HomeProjectModel(
        id: json["id"],
        name: json["name"],
        status: ProjectListModelEnumConverter.statusValues.map[json["status"]]!,
        totalUnits: json["total_units"],
        address: json["address"],
        isVerified: json["is_verified"] == "1",
        pricePerSqFeet: json["price_per_sq_feet"],
        imageLink: json["image_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": ProjectListModelEnumConverter.statusValues.reverse![status],
        "total_units": totalUnits,
        "address": address,
        "is_verified": isVerified ? "1" : "0",
        "price_per_sq_feet": pricePerSqFeet,
        "image_link": imageLink,
      };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      status,
      totalUnits,
      address,
      isVerified,
      pricePerSqFeet,
      imageLink,
    ];
  }
}

class EnumValues<T> {
  final Map<String, T> map;

  const EnumValues(this.map);

  Map<T, String>? get reverse {
    Map<T, String>? reverseMap;
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
