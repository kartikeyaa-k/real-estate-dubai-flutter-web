import 'package:equatable/equatable.dart';

import 'localized_map.dart';

class AreaCommunityDetailModel extends Equatable {
  const AreaCommunityDetailModel({
    required this.communityName,
    required this.id,
  });

  final LocalizedMap communityName;
  final int id;

  static const empty = AreaCommunityDetailModel(communityName: LocalizedMap.empty, id: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory AreaCommunityDetailModel.fromJson(Map<String, dynamic> json) => AreaCommunityDetailModel(
        communityName: LocalizedMap.fromJson(json["community_name"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "community_name": communityName.toJson(),
        "id": id,
      };

  @override
  List<Object> get props => [communityName, id];
}
