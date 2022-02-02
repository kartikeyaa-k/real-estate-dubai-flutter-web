import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:real_estate_portal/models/localized_map.dart';

PropertyTypeListModel propertyTypeModelFromJson(String str) => PropertyTypeListModel.fromJson(json.decode(str));

String propertyTypeModelToJson(PropertyTypeListModel data) => json.encode(data.toJson());

class PropertyTypeListModel extends Equatable {
  const PropertyTypeListModel({
    required this.success,
    required this.list,
  });

  final bool success;
  final List<PropertyTypeModel> list;

  static const empty = PropertyTypeListModel(success: false, list: []);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyTypeListModel.fromJson(Map<String, dynamic> json) => PropertyTypeListModel(
        success: json["success"],
        list: List<PropertyTypeModel>.from(json["list"].map((x) => PropertyTypeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [success, list];
}

class PropertyTypeModel extends Equatable {
  const PropertyTypeModel({
    required this.id,
    required this.subTypeName,
  });

  final int id;
  final LocalizedMap subTypeName;

  static const empty = PropertyTypeModel(id: -1, subTypeName: LocalizedMap.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) => PropertyTypeModel(
        id: json["id"],
        subTypeName: LocalizedMap.fromJson(json["sub_type_name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub_type_name": subTypeName.toJson(),
      };

  @override
  List<Object> get props => [id, subTypeName];
}
