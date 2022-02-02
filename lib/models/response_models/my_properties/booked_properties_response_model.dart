class BookedPropertiesResponseModel {
  bool success;
  List<BookedPropertiesModel>? properties;
  List<String>? uniqueCommunities;
  List<String>? uniquePaymentTypes;
  List<String>? uniquePropertyTypes;
  List<String>? uniqueAgencyName;

  BookedPropertiesResponseModel(
      {required this.success,
      this.properties,
      this.uniqueCommunities,
      this.uniquePaymentTypes,
      this.uniquePropertyTypes,
      this.uniqueAgencyName});

  factory BookedPropertiesResponseModel.fromJson(Map<String, dynamic> json) {
    return BookedPropertiesResponseModel(
        success: json['success'],
        properties: json['properties'] != null
            ? List<BookedPropertiesModel>.from(
                (json['properties'] as List<dynamic>)
                    .map((e) => BookedPropertiesModel.fromJson(e)))
            : [],
        uniqueCommunities: json['uniqueCommunities'].cast<String>(),
        uniquePaymentTypes: json['uniquePaymentTypes'].cast<String>(),
        uniquePropertyTypes: json['uniquePropertyTypes'].cast<String>(),
        uniqueAgencyName: json['uniqueAgencyName'].cast<String>());
  }
}

class BookedPropertiesModel {
  String agencyName;
  String paymentType;
  String propertyType;
  int propertyId;
  String propertyName;
  String coverImage;
  String price;
  int isVerified;
  int isSaved;
  String address;
  double latitude;
  double longitude;

  BookedPropertiesModel(
      {required this.agencyName,
      required this.paymentType,
      required this.propertyType,
      required this.propertyId,
      required this.propertyName,
      required this.coverImage,
      required this.price,
      required this.isVerified,
      required this.isSaved,
      required this.address,
      required this.latitude,
      required this.longitude});

  factory BookedPropertiesModel.fromJson(Map<String, dynamic> json) {
    return BookedPropertiesModel(
      agencyName: json['agency_name'],
      paymentType: json['payment_type'],
      propertyType: json['property_type'],
      propertyId: json['property_id'],
      propertyName: json['property_name'],
      coverImage: json['cover_image'],
      price: json['price'] == null ? 'TBD' : json['price'],
      isVerified: json['is_verified'],
      isSaved: json['is_saved'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
