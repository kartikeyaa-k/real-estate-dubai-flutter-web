import 'package:equatable/equatable.dart';

import '../property_details_models/property_model.dart';

class FeatureListingModel extends Equatable {
  const FeatureListingModel({
    required this.success,
    required this.featuredList,
    required this.total,
  });

  final bool success;
  final List<PropertyModel> featuredList;
  final int total;

  static const empty = FeatureListingModel(success: false, featuredList: [], total: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory FeatureListingModel.fromJson(Map<String, dynamic> json) => FeatureListingModel(
        success: json["success"],
        featuredList: List<PropertyModel>.from(json["recommendedList"].map((x) => PropertyModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "recommendedList": List<dynamic>.from(featuredList.map((x) => x.toJson())),
        "total": total,
      };

  @override
  List<Object> get props => [success, featuredList, total];
}
