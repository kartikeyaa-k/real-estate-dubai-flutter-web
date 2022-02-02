import 'package:equatable/equatable.dart';

import 'localized_map.dart';

class EmirateDetails extends Equatable {
  const EmirateDetails({
    required this.emirateName,
    required this.id,
  });

  final LocalizedMap emirateName;
  final int id;

  static const empty = EmirateDetails(emirateName: LocalizedMap.empty, id: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory EmirateDetails.fromJson(Map<String, dynamic> json) => EmirateDetails(
        emirateName: LocalizedMap.fromJson(json["emirate_name"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "emirate_name": emirateName.toJson(),
        "id": id,
      };

  @override
  List<Object> get props => [emirateName, id];
}
