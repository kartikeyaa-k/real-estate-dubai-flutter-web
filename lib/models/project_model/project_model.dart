import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../agency_model.dart';
import '../amenity_model.dart';
import '../area_community_model.dart';
import '../breadcrumb_model.dart';
import '../emirates_details_model.dart';
import '../localized_map.dart';
import '../property_media.dart';

ProjectListModel projectModelFromJson(String str) => ProjectListModel.fromJson(json.decode(str));

// String projectModelToJson(ProjectListModel data) => json.encode(data.toJson());

class ProjectListModel extends Equatable {
  const ProjectListModel({
    required this.success,
    required this.result,
  });

  final bool success;
  final ProjectResultModel result;

  static const empty = ProjectListModel(success: false, result: ProjectResultModel.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory ProjectListModel.fromJson(Map<String, dynamic> json) => ProjectListModel(
        success: json["success"],
        result: ProjectResultModel.fromJson(json["result"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "success": success,
  //       "result": result.toJson(),
  //     };

  @override
  List<Object> get props => [success, result];
}

class ProjectResultModel extends Equatable {
  const ProjectResultModel({
    required this.total,
    required this.list,
  });

  final int total;
  final List<ProjectModel> list;

  static const empty = ProjectResultModel(total: 0, list: []);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory ProjectResultModel.fromJson(Map<String, dynamic> json) => ProjectResultModel(
        total: json["total"],
        list: List<ProjectModel>.from(json["list"].map((x) => ProjectModel.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "total": total,
  //       "list": List<dynamic>.from(list.map((x) => x.toJson())),
  //     };

  @override
  List<Object> get props => [total, list];
}

class ProjectModel extends Equatable {
  const ProjectModel({
    required this.agencyDetails,
    this.amenities,
    this.features,
    this.deliveryDate,
    this.floorPlans,
    required this.isVerified,
    this.pricePerSqFeet,
    required this.projectDescription,
    required this.projectImages,
    required this.projectName,
    required this.status,
    required this.id,
    required this.totalUnits,
    required this.address,
    this.projectVideos,
    this.projectPlans,
    required this.startingPrice,
    required this.location,
    this.projectType,
    required this.emirateDetails,
    required this.areaCommunityDetails,
    this.propertyList,
    required this.breadcrumb,
  });

  static const empty = ProjectModel(
      agencyDetails: AgencyDetailsModel.empty,
      amenities: [],
      features: [],
      floorPlans: [],
      isVerified: false,
      pricePerSqFeet: 0,
      projectDescription: LocalizedMap.empty,
      projectImages: [],
      projectName: LocalizedMap.empty,
      status: "",
      id: 0,
      totalUnits: 0,
      address: LocalizedMap.empty,
      projectVideos: [],
      projectPlans: [],
      startingPrice: 0,
      location: LatLng(0, 0),
      projectType: ProjectType.empty,
      emirateDetails: EmirateDetails.empty,
      areaCommunityDetails: AreaCommunityDetailModel.empty,
      propertyList: [],
      breadcrumb: []);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  final AgencyDetailsModel agencyDetails;
  final List<AmenityModel>? amenities;
  final List<AmenityModel>? features;
  final DateTime? deliveryDate;
  final List<FloorPlanModel>? floorPlans;
  final bool isVerified;
  final int? pricePerSqFeet;
  final LocalizedMap projectDescription;
  final List<PropertyMedia> projectImages;
  final LocalizedMap projectName;
  final String status;
  final int id;
  final int totalUnits;
  final LocalizedMap? address;
  final List<PropertyMedia>? projectVideos;
  final List<ProjectPlanModel>? projectPlans;
  final int startingPrice;
  final LatLng location;
  final ProjectType? projectType;
  final EmirateDetails emirateDetails;
  final AreaCommunityDetailModel areaCommunityDetails;
  final List<ProjectPropertyModel>? propertyList;
  final List<BreadcrumbModel> breadcrumb;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        agencyDetails: AgencyDetailsModel.fromJson(json["agency_details"]),
        amenities: json["amenities"] != null
            ? List<AmenityModel>.from(json["amenities"].map((x) => AmenityModel.fromJson(x)))
            : null,
        features: json["features"] != null
            ? List<AmenityModel>.from(json["features"].map((x) => AmenityModel.fromJson(x)))
            : null,
        deliveryDate: DateTime.parse(json["delivery_date"]),
        floorPlans: json["floor_plans"] == null
            ? List<FloorPlanModel>.from(json["floor_plans"].map((x) => FloorPlanModel.fromJson(x)))
            : null,
        isVerified: json["is_verified"].toString() == "1",
        pricePerSqFeet: json["price_per_sq_feet"] != null ? json["price_per_sq_feet"] : 0,
        projectDescription: LocalizedMap.fromJson(json["project_description"]),
        projectImages: List<PropertyMedia>.from(json["project_images"].map((x) => PropertyMedia.fromJson(x))),
        projectName: LocalizedMap.fromJson(json["project_name"]),
        status: json["status"],
        id: json["id"],
        totalUnits: json["total_units"],
        address: json['address'] != null ? LocalizedMap.fromJson(json["address"]) : LocalizedMap.empty,
        projectVideos: List<PropertyMedia>.from(json["project_videos"].map((x) => PropertyMedia.fromJson(x))),
        projectPlans: json["project_plans"] != null
            ? List<ProjectPlanModel>.from(json["project_plans"].map((x) => ProjectPlanModel.fromJson(x)))
            : null,
        startingPrice: json["starting_price"],
        location: LatLng(json["location"]["lat"].toDouble(), json["location"]["lon"].toDouble()),
        projectType: json["project_type"] == null ? null : ProjectType.fromJson(json["project_type"]),
        emirateDetails: EmirateDetails.fromJson(json["emirate_details"]),
        areaCommunityDetails: AreaCommunityDetailModel.fromJson(json["area_community_details"]),
        propertyList: json["property_list"] == null
            ? List<ProjectPropertyModel>.from(json["property_list"].map((x) => ProjectPropertyModel.fromJson(x)))
            : empty.propertyList,
        breadcrumb: List<BreadcrumbModel>.from(json["breadcrumb"].map((x) => BreadcrumbModel.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "agency_details": agencyDetails.toJson(),
  //       "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
  //       "features": List<dynamic>.from(features.map((x) => x.toJson())),
  //       "delivery_date":
  //           "${deliveryDate?.year.toString().padLeft(4, '0')}-${deliveryDate?.month.toString().padLeft(2, '0')}-${deliveryDate?.day.toString().padLeft(2, '0')}",
  //       "floor_plans": floorPlans != null ? List<dynamic>.from(floorPlans!.map((x) => x.toJson())) : null,
  //       "is_verified": isVerified ? "1" : "0",
  //       "price_per_sq_feet": pricePerSqFeet,
  //       "project_description": projectDescription.toJson(),
  //       "project_images": List<dynamic>.from(projectImages.map((x) => x.toJson())),
  //       "project_name": projectName.toJson(),
  //       "status": status,
  //       "id": id,
  //       "total_units": totalUnits,
  //       "address": address == null ? LocalizedMap.empty : address?.toJson(),
  //       "project_videos": List<dynamic>.from(projectVideos.map((x) => x.toJson())),
  //       "project_plans": List<dynamic>.from(projectPlans.map((x) => x.toJson())),
  //       "starting_price": startingPrice,
  //       "location": location.toJson(),
  //       "project_type": projectType.toJson(),
  //       "emirate_details": emirateDetails.toJson(),
  //       "area_community_details": areaCommunityDetails.toJson(),
  //       "property_list": List<dynamic>.from(propertyList.map((x) => x.toJson())),
  //       "breadcrumb": List<dynamic>.from(breadcrumb.map((x) => x.toJson())),
  //     };

  @override
  List<Object?> get props {
    return [
      agencyDetails,
      amenities,
      features,
      deliveryDate,
      floorPlans,
      isVerified,
      pricePerSqFeet,
      projectDescription,
      projectImages,
      projectName,
      status,
      id,
      totalUnits,
      address,
      projectVideos,
      projectPlans,
      startingPrice,
      location,
      projectType,
      emirateDetails,
      areaCommunityDetails,
      propertyList,
      breadcrumb,
    ];
  }
}

class FloorPlanModel extends Equatable {
  const FloorPlanModel({
    required this.planName,
    required this.basePrice,
    required this.floorPlan,
    required this.areaSqFeet,
    required this.threeDPlan,
  });

  final LocalizedMap planName;
  final int basePrice;
  final String floorPlan;
  final int areaSqFeet;
  final String threeDPlan;

  static const empty =
      FloorPlanModel(planName: LocalizedMap.empty, basePrice: 0, floorPlan: "", areaSqFeet: 0, threeDPlan: "");
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory FloorPlanModel.fromJson(Map<String, dynamic> json) => FloorPlanModel(
        planName: LocalizedMap.fromJson(json["plan_name"]),
        basePrice: json["base_price"],
        floorPlan: json["floor_plan"],
        areaSqFeet: json["area_sq_feet"],
        threeDPlan: json["three_d_plan"],
      );

  Map<String, dynamic> toJson() => {
        "plan_name": planName.toJson(),
        "base_price": basePrice,
        "floor_plan": floorPlan,
        "area_sq_feet": areaSqFeet,
        "three_d_plan": threeDPlan,
      };

  @override
  List<Object> get props {
    return [
      planName,
      basePrice,
      floorPlan,
      areaSqFeet,
      threeDPlan,
    ];
  }
}

class ProjectPlanModel extends Equatable {
  const ProjectPlanModel({
    required this.id,
    required this.planName,
    required this.finalPrice,
    required this.initialPrice,
  });

  static const empty = ProjectPlanModel(id: 0, planName: LocalizedMap.empty, finalPrice: 0, initialPrice: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  final int id;
  final LocalizedMap planName;
  final int finalPrice;
  final int initialPrice;

  factory ProjectPlanModel.fromJson(Map<String, dynamic> json) => ProjectPlanModel(
        id: json["id"],
        planName: LocalizedMap.fromJson(json["plan_name"]),
        finalPrice: json["final_price"],
        initialPrice: json["initial_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_name": planName.toJson(),
        "final_price": finalPrice,
        "initial_price": initialPrice,
      };

  @override
  List<Object> get props => [id, planName, finalPrice, initialPrice];
}

class ProjectType extends Equatable {
  const ProjectType({
    this.id,
    this.name,
  });

  final int? id;
  final LocalizedMap? name;

  static const empty = ProjectType(id: 0, name: LocalizedMap.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory ProjectType.fromJson(Map<String, dynamic> json) => ProjectType(
        id: json["id"] != null ? json["id"] : 0,
        name: json["name"] != null ? LocalizedMap.fromJson(json["name"]) : null,
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name.toJson(),
  //     };

  @override
  List<Object> get props => [id ?? '', name ?? ""];
}

class ProjectPropertyModel extends Equatable {
  const ProjectPropertyModel({
    required this.address,
    required this.bathroomsCount,
    required this.bedroomsCount,
    required this.coverImage,
    required this.id,
    required this.price,
    required this.propertyName,
    required this.propertyType,
    required this.sizeInSqFeets,
  });

  final LocalizedMap address;
  final int bathroomsCount;
  final int bedroomsCount;
  final String coverImage;
  final int id;
  final int? price;
  final LocalizedMap propertyName;
  final LocalizedMap propertyType;
  final int sizeInSqFeets;

  static const empty = ProjectPropertyModel(
      address: LocalizedMap.empty,
      bathroomsCount: 0,
      bedroomsCount: 0,
      coverImage: "",
      id: 0,
      price: 0,
      propertyName: LocalizedMap.empty,
      propertyType: LocalizedMap.empty,
      sizeInSqFeets: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory ProjectPropertyModel.fromJson(Map<String, dynamic> json) => ProjectPropertyModel(
        address: LocalizedMap.fromJson(json["address"]),
        bathroomsCount: json["bathrooms_count"],
        bedroomsCount: json["bedrooms_count"],
        coverImage: json["cover_image"],
        id: json["id"],
        price: json["price"] == null ? null : json["price"],
        propertyName: LocalizedMap.fromJson(json["property_name"]),
        propertyType: LocalizedMap.fromJson(json["property_type"]),
        sizeInSqFeets: json["size_in_sq_feets"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "bathrooms_count": bathroomsCount,
        "bedrooms_count": bedroomsCount,
        "cover_image": coverImage,
        "id": id,
        "price": price == null ? null : price,
        "property_name": propertyName.toJson(),
        "property_type": propertyType.toJson(),
        "size_in_sq_feets": sizeInSqFeets,
      };

  @override
  List<Object?> get props {
    return [
      address,
      bathroomsCount,
      bedroomsCount,
      coverImage,
      id,
      price,
      propertyName,
      propertyType,
      sizeInSqFeets,
    ];
  }
}
