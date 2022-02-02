import 'dart:convert';

import 'package:equatable/equatable.dart';

PropertyLocationListModel propertyLocationFromJson(String str) => PropertyLocationListModel.fromJson(json.decode(str));

String propertyLocationToJson(PropertyLocationListModel data) => json.encode(data.toJson());

class PropertyLocationListModel extends Equatable {
  const PropertyLocationListModel({
    required this.success,
    required this.list,
  });

  final bool success;
  final List<PropertyLocationModel> list;

  static const empty = PropertyLocationListModel(success: false, list: []);

  bool get isEmpty => this == empty;

  bool get isNotEmpty => this != empty;

  factory PropertyLocationListModel.fromJson(Map<String, dynamic> json) => PropertyLocationListModel(
        success: json["success"],
        list: List<PropertyLocationModel>.from(json["list"].map((x) => PropertyLocationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [success, list];
}

class PropertyLocationModel extends Equatable {
  const PropertyLocationModel({
    required this.id,
    required this.name,
    required this.locationType,
    required this.srNumber,
  });

  final int id;
  final String name;
  final LocationType locationType;
  final int srNumber;

  factory PropertyLocationModel.fromJson(Map<String, dynamic> json) => PropertyLocationModel(
        id: json["id"],
        name: json["name"],
        locationType: locationTypeValues.map[json["location_type"]]!,
        srNumber: json["srNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location_type": locationTypeValues.reverse![locationType],
        "srNumber": srNumber,
      };

  @override
  List<Object?> get props => [id, name, locationTypeValues, srNumber];
}

enum LocationType { AREA, EMIRATE, BUILDING }

final locationTypeValues =
    EnumValues({"area_community": LocationType.AREA, "building": LocationType.BUILDING, "emirate": LocationType.EMIRATE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String>? reverseMap = {};

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
