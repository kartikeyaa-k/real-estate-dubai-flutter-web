part of 'property_listing_cubit.dart';

class PropertyListingState extends Equatable {
  const PropertyListingState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
    this.residencialProperties = const [],
    this.propertyTypeList = PropertyTypeListModel.empty,
    this.searchKeywordList = const [],
    this.planType = PlanType.RENT,
    this.propertyTypeId,
    this.minPrice,
    this.maxPrice,
    this.paymentType,
    this.furnishing,
    this.minArea,
    this.maxArea,
    this.keywords = const [],
    this.commercialProperties = const [],
    this.minBathroom,
    this.maxBathroom,
    this.maxBedroom,
    this.minBedroom,
    this.amenities = const [],
    this.selectedAmenities = const [],
    this.placesSearch = const [],
    this.sort = "",
    this.totalPropertyCount = 0,
  });

  final FormzStatus status;
  final String failureMessage;
  final List<PropertyModel> residencialProperties;
  final List<PropertyModel> commercialProperties;
  final PropertyTypeListModel propertyTypeList;
  final List<AmenityModel> amenities;
  final int totalPropertyCount;

  final List<PlacesResultModel> placesSearch;
  final List<String> searchKeywordList;
  final PlanType planType;
  final int? propertyTypeId;
  // Price attributes
  final int? minPrice;
  final int? maxPrice;
  final PaymentType? paymentType;

  // Bedroom and bathrrom attributes
  final int? minBedroom;
  final int? maxBedroom;
  final int? minBathroom;
  final int? maxBathroom;

  // amenities attributes
  final List<AmenityModel> selectedAmenities;

  final FurnishedType? furnishing;
  final double? minArea;
  final double? maxArea;
  final List<String> keywords;

  final String? sort;

  @override
  List<Object?> get props {
    return [
      status,
      failureMessage,
      residencialProperties,
      commercialProperties,
      propertyTypeList,
      searchKeywordList,
      planType,
      propertyTypeId,
      minPrice,
      maxPrice,
      paymentType,
      minBedroom,
      maxBedroom,
      minBathroom,
      maxBathroom,
      furnishing,
      minArea,
      maxArea,
      keywords,
      amenities,
      selectedAmenities,
      placesSearch,
      sort,
      totalPropertyCount,
    ];
  }

  PropertyListingState clearValues({
    List<String>? searchKeywordList,
    PlanType? planType,
    int? propertyTypeId,
    int? minPrice,
    int? maxPrice,
    PaymentType? paymentType,
    FurnishedType? furnishing,
    double? minArea,
    double? maxArea,
    List<String>? keywords,
    int? minBedroom,
    int? maxBedroom,
    int? minBathroom,
    int? maxBathroom,
    List<AmenityModel>? selectedAmenities,
    List<PlacesResultModel>? placesSearch,
    String? sort,
  }) {
    return PropertyListingState(
      // keep these attributes constant when cleared
      status: status,
      failureMessage: failureMessage,
      residencialProperties: residencialProperties,
      amenities: amenities,
      propertyTypeList: propertyTypeList,

      // changable attributes when cleared
      searchKeywordList: searchKeywordList ?? this.searchKeywordList,
      planType: planType ?? PlanType.RENT,
      propertyTypeId: propertyTypeId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      paymentType: paymentType,
      furnishing: furnishing,
      minArea: minArea,
      maxArea: maxArea,
      keywords: keywords ?? [],
      minBedroom: minBedroom,
      maxBedroom: maxBedroom,
      minBathroom: minBathroom,
      maxBathroom: maxBathroom,
      selectedAmenities: selectedAmenities ?? [],
      placesSearch: placesSearch ?? [],

      // query parameter
      sort: sort ?? "",
    );
  }

  PropertyListingState copyWith({
    FormzStatus? status,
    String? failureMessage,
    List<PropertyModel>? residencialProperties,
    List<PropertyModel>? commercialProperties,
    PropertyTypeListModel? propertyTypeList,
    List<AmenityModel>? amenities,
    List<String>? searchKeywordList,
    PlanType? planType,
    int? propertyTypeId,
    int? minPrice,
    int? maxPrice,
    PaymentType? paymentType,
    int? minBedroom,
    int? maxBedroom,
    int? minBathroom,
    int? maxBathroom,
    FurnishedType? furnishing,
    double? minArea,
    double? maxArea,
    List<String>? keywords,
    List<AmenityModel>? selectedAmenities,
    List<PlacesResultModel>? placesSearch,
    String? sort,
    int? totalPropertyCount,
  }) {
    return PropertyListingState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      residencialProperties: residencialProperties ?? this.residencialProperties,
      commercialProperties: commercialProperties ?? this.commercialProperties,
      propertyTypeList: propertyTypeList ?? this.propertyTypeList,
      amenities: amenities ?? this.amenities,
      searchKeywordList: searchKeywordList ?? this.searchKeywordList,
      planType: planType ?? this.planType,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      paymentType: paymentType ?? this.paymentType,
      minBedroom: minBedroom ?? this.minBedroom,
      maxBedroom: maxBedroom ?? this.maxBedroom,
      minBathroom: minBathroom ?? this.minBathroom,
      maxBathroom: maxBathroom ?? this.maxBathroom,
      furnishing: furnishing ?? this.furnishing,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      keywords: keywords ?? this.keywords,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      placesSearch: placesSearch ?? this.placesSearch,
      sort: sort ?? this.sort,
      totalPropertyCount: totalPropertyCount ?? this.totalPropertyCount,
    );
  }
}
