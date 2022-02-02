part of 'property_cubit.dart';

class PropertyDetailState extends Equatable {
  const PropertyDetailState({
    this.propertyDetailStatus = FormzStatus.pure,
    this.locationDetailStatus = FormzStatus.pure,
    this.failureMessage = "",
    this.propertyData = PropertyModel.empty,
    this.propertyLocationDetail = PropertyLocationDetailModel.empty,
    this.coverImage = "",
    this.sideImageUrl1 = "",
    this.sideImageUrl2 = "",
    this.isBookmarked = false,
  });

  final FormzStatus propertyDetailStatus;
  final FormzStatus locationDetailStatus;
  final String failureMessage;
  final PropertyModel propertyData;
  final PropertyLocationDetailModel propertyLocationDetail;
  final String coverImage;
  final String sideImageUrl1;
  final String sideImageUrl2;
  final bool isBookmarked;

  @override
  List<Object> get props {
    return [
      propertyDetailStatus,
      locationDetailStatus,
      failureMessage,
      propertyData,
      propertyLocationDetail,
      coverImage,
      sideImageUrl1,
      sideImageUrl2,
      isBookmarked
    ];
  }

  PropertyDetailState copyWith({
    FormzStatus? propertyDetailStatus,
    FormzStatus? locationDetailStatus,
    String? failureMessage,
    PropertyModel? propertyData,
    PropertyLocationDetailModel? propertyLocationDetail,
    String? coverImage,
    String? sideImageUrl1,
    String? sideImageUrl2,
    bool? isBookmarked,
  }) {
    return PropertyDetailState(
      propertyDetailStatus: propertyDetailStatus ?? this.propertyDetailStatus,
      locationDetailStatus: locationDetailStatus ?? this.locationDetailStatus,
      failureMessage: failureMessage ?? this.failureMessage,
      propertyData: propertyData ?? this.propertyData,
      propertyLocationDetail: propertyLocationDetail ?? this.propertyLocationDetail,
      coverImage: coverImage ?? this.coverImage,
      sideImageUrl1: sideImageUrl1 ?? this.sideImageUrl1,
      sideImageUrl2: sideImageUrl2 ?? this.sideImageUrl2,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
