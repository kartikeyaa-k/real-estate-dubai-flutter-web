import 'package:equatable/equatable.dart';

import 'localized_map.dart';

class AmenityModel extends Equatable {
  const AmenityModel({
    required this.name,
    required this.logo,
    required this.id,
  });

  final LocalizedMap name;
  final String? logo;
  final int id;

  static const empty = AmenityModel(id: -1, logo: "", name: LocalizedMap.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory AmenityModel.fromJson(Map<String, dynamic> json) => AmenityModel(
        name: LocalizedMap.fromJson(json["name"]),
        logo: json["logo"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name.toJson(),
        "logo": logo,
        "id": id,
      };

  @override
  List<Object?> get props => [name, logo, id];
}
