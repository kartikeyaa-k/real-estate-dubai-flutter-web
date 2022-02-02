// class CommunityPropertiesResponseModel {
//   bool success;
//   Result result;

//   CommunityPropertiesResponseModel({this.success, this.result});

//   CommunityPropertiesResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     result =
//         json['result'] != null ? new Result.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.result != null) {
//       data['result'] = this.result.toJson();
//     }
//     return data;
//   }
// }





// class Result {

//   List<List> list;
//   List<Aggregations> aggregations;
//   int total;

//   Result({this.list, this.aggregations, this.total});

//   Result.fromJson(Map<String, dynamic> json) {
//     if (json['list'] != null) {
//       list = new List<List>();
//       json['list'].forEach((v) {
//         list.add(new List.fromJson(v));
//       });
//     }
//     if (json['aggregations'] != null) {
//       aggregations = new List<Aggregations>();
//       json['aggregations'].forEach((v) {
//         aggregations.add(new Aggregations.fromJson(v));
//       });
//     }
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.list != null) {
//       data['list'] = this.list.map((v) => v.toJson()).toList();
//     }
//     if (this.aggregations != null) {
//       data['aggregations'] = this.aggregations.map((v) => v.toJson()).toList();
//     }
//     data['total'] = this.total;
//     return data;
//   }
// }



// class List {
//   String status;
//   List<Features> features;
//   List<Amenities> amenities;
//   int unitNumber;
//   int floorNumber;
//   AgencyDetails agencyDetails;
//   String datePublished;
//   EmirateDetails emirateDetails;
//   List<PropertyImages> propertyImages;
//   List<PropertyVideos> propertyVideos;
//   BuildingDetails buildingDetails;
//   PropertyDetails propertyDetails;
//   int averageAreaRating;
//   AreaCommunityDetails areaCommunityDetails;
//   int averageBuildingRating;
//   int averagePropertyRating;
//   List<PropertyRentOrBuyPlans> propertyRentOrBuyPlans;
//   int netReviewCount;
//   List<Breadcrumb> breadcrumb;

//   List(
//       {this.status,
//       this.features,
//       this.amenities,
//       this.unitNumber,
//       this.floorNumber,
//       this.agencyDetails,
//       this.datePublished,
//       this.emirateDetails,
//       this.propertyImages,
//       this.propertyVideos,
//       this.buildingDetails,
//       this.propertyDetails,
//       this.averageAreaRating,
//       this.areaCommunityDetails,
//       this.averageBuildingRating,
//       this.averagePropertyRating,
//       this.propertyRentOrBuyPlans,
//       this.netReviewCount,
//       this.breadcrumb});

//   List.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['features'] != null) {
//       features = new List<Features>();
//       json['features'].forEach((v) {
//         features.add(new Features.fromJson(v));
//       });
//     }
//     if (json['amenities'] != null) {
//       amenities = new List<Amenities>();
//       json['amenities'].forEach((v) {
//         amenities.add(new Amenities.fromJson(v));
//       });
//     }
//     unitNumber = json['unit_number'];
//     floorNumber = json['floor_number'];
//     agencyDetails = json['agency_details'] != null
//         ? new AgencyDetails.fromJson(json['agency_details'])
//         : null;
//     datePublished = json['date_published'];
//     emirateDetails = json['emirate_details'] != null
//         ? new EmirateDetails.fromJson(json['emirate_details'])
//         : null;
//     if (json['property_images'] != null) {
//       propertyImages = new List<PropertyImages>();
//       json['property_images'].forEach((v) {
//         propertyImages.add(new PropertyImages.fromJson(v));
//       });
//     }
//     if (json['property_videos'] != null) {
//       propertyVideos = new List<PropertyVideos>();
//       json['property_videos'].forEach((v) {
//         propertyVideos.add(new PropertyVideos.fromJson(v));
//       });
//     }
//     buildingDetails = json['building_details'] != null
//         ? new BuildingDetails.fromJson(json['building_details'])
//         : null;
//     propertyDetails = json['property_details'] != null
//         ? new PropertyDetails.fromJson(json['property_details'])
//         : null;
//     averageAreaRating = json['average_area_rating'];
//     areaCommunityDetails = json['area_community_details'] != null
//         ? new AreaCommunityDetails.fromJson(json['area_community_details'])
//         : null;
//     averageBuildingRating = json['average_building_rating'];
//     averagePropertyRating = json['average_property_rating'];
//     if (json['property_rent_or_buy_plans'] != null) {
//       propertyRentOrBuyPlans = new List<PropertyRentOrBuyPlans>();
//       json['property_rent_or_buy_plans'].forEach((v) {
//         propertyRentOrBuyPlans.add(new PropertyRentOrBuyPlans.fromJson(v));
//       });
//     }
//     netReviewCount = json['net_review_count'];
//     if (json['breadcrumb'] != null) {
//       breadcrumb = new List<Breadcrumb>();
//       json['breadcrumb'].forEach((v) {
//         breadcrumb.add(new Breadcrumb.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.features != null) {
//       data['features'] = this.features.map((v) => v.toJson()).toList();
//     }
//     if (this.amenities != null) {
//       data['amenities'] = this.amenities.map((v) => v.toJson()).toList();
//     }
//     data['unit_number'] = this.unitNumber;
//     data['floor_number'] = this.floorNumber;
//     if (this.agencyDetails != null) {
//       data['agency_details'] = this.agencyDetails.toJson();
//     }
//     data['date_published'] = this.datePublished;
//     if (this.emirateDetails != null) {
//       data['emirate_details'] = this.emirateDetails.toJson();
//     }
//     if (this.propertyImages != null) {
//       data['property_images'] =
//           this.propertyImages.map((v) => v.toJson()).toList();
//     }
//     if (this.propertyVideos != null) {
//       data['property_videos'] =
//           this.propertyVideos.map((v) => v.toJson()).toList();
//     }
//     if (this.buildingDetails != null) {
//       data['building_details'] = this.buildingDetails.toJson();
//     }
//     if (this.propertyDetails != null) {
//       data['property_details'] = this.propertyDetails.toJson();
//     }
//     data['average_area_rating'] = this.averageAreaRating;
//     if (this.areaCommunityDetails != null) {
//       data['area_community_details'] = this.areaCommunityDetails.toJson();
//     }
//     data['average_building_rating'] = this.averageBuildingRating;
//     data['average_property_rating'] = this.averagePropertyRating;
//     if (this.propertyRentOrBuyPlans != null) {
//       data['property_rent_or_buy_plans'] =
//           this.propertyRentOrBuyPlans.map((v) => v.toJson()).toList();
//     }
//     data['net_review_count'] = this.netReviewCount;
//     if (this.breadcrumb != null) {
//       data['breadcrumb'] = this.breadcrumb.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }





// class Features {
//   int id;
//   Null logo;
//   Name name;

//   Features({this.id, this.logo, this.name});

//   Features.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     logo = json['logo'];
//     name = json['name'] != null ? new Name.fromJson(json['name']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['logo'] = this.logo;
//     if (this.name != null) {
//       data['name'] = this.name.toJson();
//     }
//     return data;
//   }
// }


// class Name {
//   String ar;
//   String en;
//   String lan;

//   Name({this.ar, this.en, this.lan});

//   Name.fromJson(Map<String, dynamic> json) {
//     ar = json['ar'];
//     en = json['en'];
//     lan = json['lan'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ar'] = this.ar;
//     data['en'] = this.en;
//     data['lan'] = this.lan;
//     return data;
//   }
// }