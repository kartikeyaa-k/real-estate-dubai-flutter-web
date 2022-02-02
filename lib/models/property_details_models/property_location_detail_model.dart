import 'dart:convert';

import 'package:equatable/equatable.dart';

PropertyLocationDetailModel propertyLocationDetailModelFromJson(String str) =>
    PropertyLocationDetailModel.fromJson(json.decode(str));

String propertyLocationDetailModelToJson(PropertyLocationDetailModel data) => json.encode(data.toJson());

class PropertyLocationDetailModel extends Equatable {
  const PropertyLocationDetailModel({
    required this.distanceHospital,
    required this.distanceSchool,
    required this.distanceAirport,
    required this.distanceBusStation,
    required this.distanceTrainStation,
  });

  final String distanceHospital;
  final String distanceSchool;
  final String distanceAirport;
  final String distanceBusStation;
  final String distanceTrainStation;

  static const empty = PropertyLocationDetailModel(
      distanceHospital: "", distanceSchool: "", distanceAirport: "", distanceBusStation: "", distanceTrainStation: "");
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyLocationDetailModel.fromJson(Map<String, dynamic> json) => PropertyLocationDetailModel(
        distanceHospital: json["distanceHospital"] ?? "-",
        distanceSchool: json["distanceSchool"] ?? "-",
        distanceAirport: json["distanceAirport"] ?? "-",
        distanceBusStation: json["distanceBusStation"] ?? "-",
        distanceTrainStation: json["distanceTrainStation"] ?? "-",
      );

  Map<String, dynamic> toJson() => {
        "distanceHospital": distanceHospital,
        "distanceSchool": distanceSchool,
        "distanceAirport": distanceAirport,
        "distanceBusStation": distanceBusStation,
        "distanceTrainStation": distanceTrainStation,
      };

  @override
  List<Object> get props {
    return [
      distanceHospital,
      distanceSchool,
      distanceAirport,
      distanceBusStation,
      distanceTrainStation,
    ];
  }
}
