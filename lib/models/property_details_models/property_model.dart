import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../agency_model.dart';
import '../amenity_model.dart';
import '../area_community_model.dart';
import '../breadcrumb_model.dart';
import '../emirates_details_model.dart';
import '../enum_values_converter.dart';
import '../localized_map.dart';
import '../property_media.dart';

enum FurnishedType { ANY, SEMI_FURNISHED, FULLY_FURNISHED, FURNISHED, UNFURNISHED }

enum PropertyType { RESIDENTIAL, COMMERCIAL }

enum PlanType { BUY, RENT }

enum PaymentType { MONTHLY, HALF_YEARLY, QUARTERLY, YEARLY }

class PropertyModelEnumConverter {
  static const furnishedStatusValues = EnumValues({
    "ANY": FurnishedType.ANY,
    "Furnished": FurnishedType.FURNISHED,
    "Unfurnished": FurnishedType.UNFURNISHED,
    "Semi-furnished": FurnishedType.SEMI_FURNISHED,
    "Fully-furnished": FurnishedType.FULLY_FURNISHED
  });

  static const planTypeValues = EnumValues({"BUY": PlanType.BUY, "RENT": PlanType.RENT});

  static const propertyTypeValues =
      EnumValues({"Commercial": PropertyType.COMMERCIAL, "Residential": PropertyType.RESIDENTIAL});

  static const paymentTypeValues = EnumValues({
    "Monthly": PaymentType.MONTHLY,
    "Half Yearly": PaymentType.HALF_YEARLY,
    "Quarterly": PaymentType.QUARTERLY,
    "Yearly": PaymentType.YEARLY
  });
}

PropertyListingListModel propertyListingModelFromJson(String str) =>
    PropertyListingListModel.fromJson(json.decode(str));

String propertyListingModelToJson(PropertyListingListModel data) => json.encode(data.toJson());

// ======================================================================
// Models
// ======================================================================

class PropertyListingListModel extends Equatable {
  const PropertyListingListModel({
    required this.success,
    required this.result,
  });

  final bool success;
  final PropertyListingListResult result;

  static const empty = PropertyListingListModel(success: false, result: PropertyListingListResult.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyListingListModel.fromJson(Map<String, dynamic> json) => PropertyListingListModel(
        success: json["success"],
        result: PropertyListingListResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result.toJson(),
      };

  @override
  List<Object> get props => [success, result];
}

class PropertyListingListResult extends Equatable {
  const PropertyListingListResult({
    required this.list,
    required this.aggregations,
    required this.total,
  });

  final List<PropertyModel> list;
  final List<AggregationModel> aggregations;
  final int total;

  static const empty = PropertyListingListResult(list: [], aggregations: [], total: -1);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyListingListResult.fromJson(Map<String, dynamic> json) => PropertyListingListResult(
      list: List<PropertyModel>.from(json["list"].map((x) => PropertyModel.fromJson(x))),
      aggregations: List<AggregationModel>.from(json["aggregations"].map((x) => AggregationModel.fromJson(x))),
      total: json['total']);

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "aggregations": List<dynamic>.from(aggregations.map((x) => x.toJson())),
        "total": total
      };

  @override
  List<Object> get props => [list, aggregations, total];
}

class AggregationModel extends Equatable {
  const AggregationModel({
    required this.key,
    required this.docCount,
  });

  final String key;
  final int docCount;

  static const empty = AggregationModel(key: "", docCount: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory AggregationModel.fromJson(Map<String, dynamic> json) => AggregationModel(
        key: json["key"],
        docCount: json["doc_count"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "doc_count": docCount,
      };

  @override
  List<Object> get props => [key, docCount];
}

class PropertyModel extends Equatable {
  const PropertyModel({
    required this.status,
    required this.features,
    required this.amenities,
    required this.unitNumber,
    required this.floorNumber,
    required this.agencyDetails,
    this.datePublished,
    required this.emirateDetails,
    required this.propertyImages,
    required this.propertyVideos,
    required this.buildingDetails,
    required this.propertyDetails,
    required this.averageAreaRating,
    required this.areaCommunityDetails,
    required this.averageBuildingRating,
    required this.averagePropertyRating,
    required this.propertyRentOrBuyPlans,
    required this.netReviewCount,
    required this.breadcrumb,
  });

  final String status;
  final List<AmenityModel> features;
  final List<AmenityModel> amenities;
  final int unitNumber;
  final int floorNumber;
  final AgencyDetailsModel agencyDetails;
  final DateTime? datePublished;
  final EmirateDetails emirateDetails;
  final List<PropertyMedia> propertyImages;
  final List<PropertyMedia> propertyVideos;
  final BuildingDetails buildingDetails;
  final PropertyDetailsModel propertyDetails;
  final int averageAreaRating;
  final AreaCommunityDetailModel areaCommunityDetails;
  final int averageBuildingRating;
  final int averagePropertyRating;
  final List<PropertyRentOrBuyPlan> propertyRentOrBuyPlans;
  final int netReviewCount;
  final List<BreadcrumbModel> breadcrumb;

  static const empty = PropertyModel(
      status: "",
      features: [],
      amenities: [],
      unitNumber: 0,
      floorNumber: 0,
      agencyDetails: AgencyDetailsModel.empty,
      emirateDetails: EmirateDetails.empty,
      propertyImages: [],
      propertyVideos: [],
      buildingDetails: BuildingDetails.empty,
      propertyDetails: PropertyDetailsModel.empty,
      averageAreaRating: 0,
      areaCommunityDetails: AreaCommunityDetailModel.empty,
      averageBuildingRating: -1,
      averagePropertyRating: -1,
      propertyRentOrBuyPlans: [],
      netReviewCount: -1,
      breadcrumb: []);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
        status: json["status"],
        features: List<AmenityModel>.from(json["features"].map((x) => AmenityModel.fromJson(x))),
        amenities: List<AmenityModel>.from(json["amenities"].map((x) => AmenityModel.fromJson(x))),
        unitNumber: json["unit_number"],
        floorNumber: json["floor_number"],
        agencyDetails: AgencyDetailsModel.fromJson(json["agency_details"]),
        datePublished: DateTime.parse(json["date_published"]),
        emirateDetails: EmirateDetails.fromJson(json["emirate_details"]),
        propertyImages: List<PropertyMedia>.from(json["property_images"].map((x) => PropertyMedia.fromJson(x))),
        propertyVideos: List<PropertyMedia>.from(json["property_videos"].map((x) => PropertyMedia.fromJson(x))),
        buildingDetails: BuildingDetails.fromJson(json["building_details"]),
        propertyDetails: PropertyDetailsModel.fromJson(json["property_details"]),
        averageAreaRating: json["average_area_rating"],
        areaCommunityDetails: AreaCommunityDetailModel.fromJson(json["area_community_details"]),
        averageBuildingRating: json["average_building_rating"],
        averagePropertyRating: json["average_property_rating"],
        propertyRentOrBuyPlans: List<PropertyRentOrBuyPlan>.from(
            json["property_rent_or_buy_plans"].map((x) => PropertyRentOrBuyPlan.fromJson(x))),
        netReviewCount: json["net_review_count"],
        breadcrumb: List<BreadcrumbModel>.from(json["breadcrumb"].map((x) => BreadcrumbModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
        "unit_number": unitNumber,
        "floor_number": floorNumber,
        "agency_details": agencyDetails.toJson(),
        "date_published":
            "${datePublished?.year.toString().padLeft(4, '0')}-${datePublished?.month.toString().padLeft(2, '0')}-${datePublished?.day.toString().padLeft(2, '0')}",
        "emirate_details": emirateDetails.toJson(),
        "property_images": List<dynamic>.from(propertyImages.map((x) => x.toJson())),
        "property_videos": List<dynamic>.from(propertyVideos.map((x) => x.toJson())),
        "building_details": buildingDetails.toJson(),
        "property_details": propertyDetails.toJson(),
        "average_area_rating": averageAreaRating,
        "area_community_details": areaCommunityDetails.toJson(),
        "average_building_rating": averageBuildingRating,
        "average_property_rating": averagePropertyRating,
        "property_rent_or_buy_plans": List<dynamic>.from(propertyRentOrBuyPlans.map((x) => x.toJson())),
        "net_review_count": netReviewCount,
        "breadcrumb": List<dynamic>.from(breadcrumb.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props {
    return [
      status,
      features,
      amenities,
      unitNumber,
      floorNumber,
      agencyDetails,
      datePublished,
      emirateDetails,
      propertyImages,
      propertyVideos,
      buildingDetails,
      propertyDetails,
      averageAreaRating,
      areaCommunityDetails,
      averageBuildingRating,
      averagePropertyRating,
      propertyRentOrBuyPlans,
      netReviewCount,
      breadcrumb,
    ];
  }
}

class BuildingDetails extends Equatable {
  const BuildingDetails({this.buildingName, this.id});

  final LocalizedMap? buildingName;
  final int? id;

  static const empty = BuildingDetails(buildingName: LocalizedMap.empty, id: -1);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory BuildingDetails.fromJson(Map<String, dynamic> json) => BuildingDetails(
        buildingName: json["building_name"] == null ? null : LocalizedMap.fromJson(json["building_name"]),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "building_name": buildingName == null ? null : buildingName?.toJson(),
        "id": id == null ? null : id,
      };

  @override
  List<Object?> get props => [buildingName, id];
}

class PropertyDetailsModel extends Equatable {
  const PropertyDetailsModel({
    required this.isRentingAvailable,
    required this.propertyDescription,
    required this.address,
    required this.sizeInSqFeets,
    this.furnishedStatus,
    required this.bathroomsCount,
    required this.govtPermitNumber,
    required this.isVerified,
    required this.referenceNumber,
    required this.bedroomsCount,
    required this.propertySellingPrice,
    required this.propertyName,
    required this.subType,
    this.toursAvailable,
    required this.roomStructure,
    this.propertyType,
    required this.location,
    required this.id,
    required this.coverImage,
    required this.isBuyAvailable,
    required this.isFeatured,
  });

  final int id;
  final LocalizedMap address;
  final SubType subType;
  final String coverImage;
  final bool isFeatured;
  final bool isVerified;
  final LocalizedMap propertyName;
  final PropertyType? propertyType;
  final int bedroomsCount;
  final List<RoomStructure> roomStructure;
  final int bathroomsCount;
  final List<String>? toursAvailable;
  final FurnishedType? furnishedStatus;
  final bool isBuyAvailable;
  final String referenceNumber;
  final double sizeInSqFeets;
  final String govtPermitNumber;
  final bool isRentingAvailable;
  final LocalizedMap propertyDescription;
  final double? propertySellingPrice;
  final LatLng location;

  static const empty = PropertyDetailsModel(
    isRentingAvailable: false,
    propertyDescription: LocalizedMap.empty,
    address: LocalizedMap.empty,
    sizeInSqFeets: 0,
    bathroomsCount: 0,
    govtPermitNumber: "",
    isVerified: false,
    referenceNumber: "",
    bedroomsCount: 0,
    propertySellingPrice: 0,
    propertyName: LocalizedMap.empty,
    subType: SubType.empty,
    roomStructure: [],
    location: LatLng(0, 0),
    id: 0,
    coverImage: "",
    isBuyAvailable: false,
    isFeatured: false,
  );
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) => PropertyDetailsModel(
        id: json["id"],
        address: LocalizedMap.fromJson(json["address"]),
        subType: SubType.fromJson(json["sub_type"]),
        coverImage: json["cover_image"],
        isFeatured: json["is_featured"].toString() == "1",
        isVerified: json["is_verified"].toString() == "1",
        propertyName: LocalizedMap.fromJson(json["property_name"]),
        propertyType: PropertyModelEnumConverter.propertyTypeValues.map[json["property_type"]],
        bedroomsCount: json["bedrooms_count"],
        roomStructure: List<RoomStructure>.from(json["room_structure"].map((x) => RoomStructure.fromJson(x))),
        bathroomsCount: json["bathrooms_count"],
        toursAvailable: json["tours_available"],
        furnishedStatus: PropertyModelEnumConverter.furnishedStatusValues.map[json["furnished_status"]],
        isBuyAvailable: json["is_buy_available"].toString() == "1",
        referenceNumber: json["reference_number"],
        sizeInSqFeets: json["size_in_sq_feets"].toDouble(),
        govtPermitNumber: json["govt_permit_number"],
        isRentingAvailable: json["is_renting_available"].toString() == "1",
        propertyDescription: LocalizedMap.fromJson(json["property_description"]),
        propertySellingPrice: json["property_selling_price"] != null && json["property_selling_price"] != "null"
            ? json["property_selling_price"].runtimeType is String
                ? double.tryParse(json["property_selling_price"])
                : (json["property_selling_price"] as int).toDouble()
            : null,
        location: LatLng(json["location"]["lat"].toDouble(), json["location"]["lon"].toDouble()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address.toJson(),
        "sub_type": subType.toJson(),
        "cover_image": coverImage,
        "is_featured": isFeatured ? "1" : "0",
        "is_verified": isVerified ? "1" : "0",
        "property_name": propertyName.toJson(),
        "property_type": PropertyModelEnumConverter.propertyTypeValues.reverse?[propertyType],
        "bedrooms_count": bedroomsCount,
        "room_structure": List<RoomStructure>.from(roomStructure.map((x) => x.toJson())),
        "bathrooms_count": bathroomsCount,
        "tours_available": List<String>.from(toursAvailable?.map((x) => x) ?? []),
        "furnished_status": PropertyModelEnumConverter.furnishedStatusValues.reverse?[furnishedStatus],
        "is_buy_available": isBuyAvailable ? "1" : "0",
        "reference_number": referenceNumber,
        "size_in_sq_feets": sizeInSqFeets,
        "govt_permit_number": govtPermitNumber,
        "is_renting_available": isRentingAvailable ? "1" : "0",
        "property_description": propertyDescription.toJson(),
        "property_selling_price": propertySellingPrice,
        "location": location.toJson(),
      };

  @override
  List<Object?> get props {
    return [
      id,
      address,
      subType,
      coverImage,
      isFeatured,
      isVerified,
      propertyName,
      propertyType,
      bedroomsCount,
      roomStructure,
      bathroomsCount,
      toursAvailable,
      furnishedStatus,
      isBuyAvailable,
      referenceNumber,
      sizeInSqFeets,
      govtPermitNumber,
      isRentingAvailable,
      propertyDescription,
      propertySellingPrice,
      location,
    ];
  }
}

class SubType extends Equatable {
  const SubType({
    required this.name,
    required this.id,
  });

  final LocalizedMap name;
  final int id;

  static const empty = SubType(name: LocalizedMap.empty, id: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory SubType.fromJson(Map<String, dynamic> json) => SubType(
        name: LocalizedMap.fromJson(json["name"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name.toJson(),
        "id": id,
      };

  @override
  List<Object> get props => [name, id];
}

class PropertyRentOrBuyPlan extends Equatable {
  const PropertyRentOrBuyPlan({
    this.planType,
    required this.price,
    required this.planId,
    required this.planName,
  });

  final PlanType? planType;
  final double price;
  final int planId;
  final LocalizedMap planName;

  static const empty = PropertyRentOrBuyPlan(price: 0, planId: 0, planName: LocalizedMap.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyRentOrBuyPlan.fromJson(Map<String, dynamic> json) => PropertyRentOrBuyPlan(
        planType: PropertyModelEnumConverter.planTypeValues.map[json["plan_type"]],
        price: json["price"] != null ? json["price"].toDouble() : 0,
        planId: json["plan_id"] != null ? json["plan_id"] : 0,
        planName: json["plan_name"] != null ? LocalizedMap.fromJson(json["plan_name"]) : LocalizedMap.empty,
      );

  Map<String, dynamic> toJson() => {
        "plan_type": PropertyModelEnumConverter.planTypeValues.reverse?[planType],
        "price": price,
        "plan_id": planId,
        "plan_name": planName.toJson(),
      };

  @override
  List<Object?> get props => [planType, price, planId, planName];
}

class RoomStructure {
  const RoomStructure({
    required this.roomCount,
    required this.roomTypeName,
  });

  final int roomCount;
  final LocalizedMap roomTypeName;

  static const empty = RoomStructure(roomCount: 0, roomTypeName: LocalizedMap.empty);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory RoomStructure.fromJson(Map<String, dynamic> json) => RoomStructure(
        roomCount: json["room_count"],
        roomTypeName: LocalizedMap.fromJson(json["room_type_name"]),
      );

  Map<String, dynamic> toJson() => {
        "room_count": roomCount,
        "room_type_name": roomTypeName.toJson(),
      };
}
