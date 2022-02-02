import 'package:equatable/equatable.dart';

import 'enum_values_converter.dart';
import 'localized_map.dart';

enum LocationType { AREA_COMMUNITY, EMIRATE }

final locationTypeValues = EnumValues({"area_community": LocationType.AREA_COMMUNITY, "emirate": LocationType.EMIRATE});

class BreadcrumbModel extends Equatable {
  const BreadcrumbModel({
    required this.id,
    required this.locationType,
    required this.name,
    required this.depth,
  });

  final int id;
  final LocationType locationType;
  final LocalizedMap name;
  final int depth;

  static const empty =
      BreadcrumbModel(id: 0, locationType: LocationType.AREA_COMMUNITY, name: LocalizedMap.empty, depth: -1);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory BreadcrumbModel.fromJson(Map<String, dynamic> json) => BreadcrumbModel(
        id: json["id"],
        locationType: locationTypeValues.map[json["location_type"]]!,
        name: LocalizedMap.fromJson(json["name"]),
        depth: json["depth"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_type": locationTypeValues.reverse![locationType],
        "name": name.toJson(),
        "depth": depth,
      };

  @override
  List<Object> get props => [id, locationType, name, depth];
}
