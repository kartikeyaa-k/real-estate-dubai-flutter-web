part of 'home_filter_bloc.dart';

class HomeFilterState extends Equatable {
  const HomeFilterState({
    this.isLoadingPropertyTypes = false,
    this.searchStatus = FormzStatus.pure,
    this.suggestedPlaces = SuggestPlacesModel.empty,
    this.propertyTypeList = PropertyTypeListModel.empty,
    this.searchFailureMessage = "",
    this.searchKeywordList = "",
    this.lookingFor = "",
    this.propertyTypeId,
    this.minPrice,
    this.maxPrice,
    this.furnishing = "",
    this.minArea,
    this.maxArea,
    this.keywords = "",
  });

  // loaded data
  final bool isLoadingPropertyTypes;
  final SuggestPlacesModel suggestedPlaces;
  final PropertyTypeListModel propertyTypeList;
  final FormzStatus searchStatus;

  final String searchFailureMessage;
  final String searchKeywordList;
  final String lookingFor;
  final int? propertyTypeId;
  final int? minPrice;
  final int? maxPrice;
  final String furnishing;
  final int? minArea;
  final int? maxArea;
  final String keywords;

  @override
  List<Object?> get props {
    return [
      isLoadingPropertyTypes,
      suggestedPlaces,
      propertyTypeList,
      searchFailureMessage,
      searchKeywordList,
      lookingFor,
      propertyTypeId,
      minPrice,
      maxPrice,
      furnishing,
      minArea,
      maxArea,
      keywords,
      searchStatus,
    ];
  }

  HomeFilterState copyWith({
    bool? isLoadingPropertyTypes,
    SuggestPlacesModel? suggestedPlaces,
    PropertyTypeListModel? propertyTypeList,
    String? searchFailureMessage,
    String? searchKeywordList,
    String? lookingFor,
    int? propertyTypeId,
    int? minPrice,
    int? maxPrice,
    String? furnishing,
    int? minArea,
    int? maxArea,
    String? keywords,
    FormzStatus? searchStatus,
  }) {
    return HomeFilterState(
      isLoadingPropertyTypes: isLoadingPropertyTypes ?? this.isLoadingPropertyTypes,
      suggestedPlaces: suggestedPlaces ?? this.suggestedPlaces,
      propertyTypeList: propertyTypeList ?? this.propertyTypeList,
      searchFailureMessage: searchFailureMessage ?? this.searchFailureMessage,
      searchKeywordList: searchKeywordList ?? this.searchKeywordList,
      lookingFor: lookingFor ?? this.lookingFor,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      furnishing: furnishing ?? this.furnishing,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      keywords: keywords ?? this.keywords,
      searchStatus: searchStatus ?? this.searchStatus,
    );
  }
}
