import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/models/home_page_model/suggest_places_model.dart';

import '../../../models/amenity_model.dart';
import '../../../models/home_page_model/property_types_model.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../services/home/home_services.dart';
import '../../../services/property_services/property_services.dart';

part 'property_listing_state.dart';

class PropertyListingCubit extends Cubit<PropertyListingState> {
  PropertyServices _propertyServices;
  HomeServices _homeServices;

  PropertyListingCubit({required PropertyServices propertyServices, required HomeServices homeServices})
      : _propertyServices = propertyServices,
        _homeServices = homeServices,
        super(PropertyListingState());

  /*--------------------------------------------*/

  void initPropertyListing({
    List<PlacesResultModel>? placesSearch,
    List<String>? keywords,
    FurnishedType? furnishedType,
    required PlanType planType,
    int? propertyTypeId,
    int? minPrice,
    int? maxPrice,
    PaymentType? paymentType,
    double? minArea,
    double? maxArea,
    String? sort,
    int? minBedroom,
    int? maxBedroom,
    int? minBathroom,
    int? maxBathroom,
    int? limit,
    int? offset,
  }) async {
    // if (keywords != state.keywords ||
    //     propertyTypeId != state.propertyTypeId ||
    //     furnishedType != state.furnishing ||
    //     maxArea != state.maxArea ||
    //     minArea != state.minArea ||
    //     maxPrice != state.maxPrice ||
    //     paymentType != state.paymentType ||
    //     planType != state.planType ||
    //     placesSearch != state.placesSearch ||
    //     sort != state.sort) {
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        keywords: keywords,
        propertyTypeId: propertyTypeId,
        furnishing: furnishedType,
        maxArea: maxArea,
        minArea: minArea,
        maxPrice: maxPrice,
        minPrice: minPrice,
        paymentType: paymentType,
        planType: planType,
        placesSearch: placesSearch,
        sort: sort,
        minBedroom: minBedroom,
        maxBedroom: maxBedroom,
        minBathroom: minBathroom,
        maxBathroom: maxBathroom));

    final propertyEither = await _propertyServices.getSearchFilter(
        keywordArray: keywords,
        furnishingType: furnishedType,
        planType: planType,
        propertySubTypeId: propertyTypeId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        paymentType: paymentType,
        minArea: minArea,
        maxArea: maxArea,
        locationArray: placesSearch,
        sort: sort,
        minBedrooms: minBedroom,
        maxBedrooms: maxBedroom,
        minBathrooms: minBathroom,
        maxBathrooms: maxBathroom,
        limit: limit,
        offset: offset);

    propertyEither.fold(
      (failure) => emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage)),
      (PropertyListingListModel propertyListingListModel) {
        final residencial = propertyListingListModel.result.list
            .where((element) => element.propertyDetails.propertyType == PropertyType.RESIDENTIAL)
            .toList();
        final commercial = propertyListingListModel.result.list
            .where((element) => element.propertyDetails.propertyType == PropertyType.COMMERCIAL)
            .toList();

        emit(
          state.copyWith(
            residencialProperties: residencial,
            commercialProperties: commercial,
            totalPropertyCount: propertyListingListModel.result.total,
            status: FormzStatus.submissionSuccess,
          ),
        );
      },
    );
    // }
  }

  /*--------------------------------------------*/

  void loadFilterData() async {
    final propertyTypeEither = await _homeServices.getPropertyTypes();

    final amenitiesEither = await _homeServices.getAmenities();

    propertyTypeEither.fold(
      (failure) => null,
      (propertyTypeList) => emit(state.copyWith(propertyTypeList: propertyTypeList)),
    );

    amenitiesEither.fold(
      (l) => null,
      (amenities) => emit(state.copyWith(amenities: amenities)),
    );
  }

  /*--------------------------------------------*/

  void keywordsChanged(List<String> keywords) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, keywords: keywords));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onMinPriceChanged(int? minPrice) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, minPrice: minPrice));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onMaxPriceChanged(int? maxPrice) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, maxPrice: maxPrice));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onPayTypeChanged(PaymentType? paymentType) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, paymentType: paymentType));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onMinAreaChanged(double? minArea) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, minArea: minArea));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onMaxAreaChanged(double? maxArea) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, maxArea: maxArea));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onFurnishingChanged(FurnishedType? furnishing) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, furnishing: furnishing));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onPropertyTypeChanged(int? propertyTypeId) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, propertyTypeId: propertyTypeId));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onMinBedroomChanged(int? value) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, minBedroom: value));
    await _getSearchData();
  }

  void onMaxBedroomChanged(int? value) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, maxBedroom: value));
    await _getSearchData();
  }

  void onMinBathroomChanged(int? value) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, minBathroom: value));
    await _getSearchData();
  }

  void onMaxBathroomChanged(int? value) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, maxBathroom: value));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void onAmenitiesChanged(List<AmenityModel> amenities) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress, selectedAmenities: amenities));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void clearAllFilters() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    // using clear values method as passing null will not clear the state in copyWith
    emit(state.clearValues(
      furnishing: null,
      keywords: null,
      maxArea: null,
      maxPrice: null,
      minArea: null,
      minPrice: null,
      paymentType: null,
      planType: null,
      propertyTypeId: null,
      searchKeywordList: null,
      minBathroom: null,
      maxBathroom: null,
      maxBedroom: null,
      minBedroom: null,
      selectedAmenities: null,
    ));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void clearPriceSection() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    emit(state.clearValues(minPrice: null, maxPrice: null, paymentType: null));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void clearAmenities() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    emit(state.clearValues(selectedAmenities: null));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  _getSearchData() async {
    final propertyEither = await _propertyServices.getSearchFilter(
      keywordArray: state.keywords,
      furnishingType: state.furnishing,
      planType: state.planType,
      propertySubTypeId: state.propertyTypeId,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      paymentType: state.paymentType,
      minArea: state.minArea,
      maxArea: state.maxArea,
      minBathrooms: state.minBathroom,
      maxBathrooms: state.maxBathroom,
      minBedrooms: state.minBedroom,
      maxBedrooms: state.maxBedroom,
      amenityIds: state.selectedAmenities.map((e) => e.id).toList(),
    );

    propertyEither.fold(
      (failure) => emit(state.copyWith(failureMessage: failure.errorMessage, status: FormzStatus.submissionFailure)),
      (propertyListingListModel) {
        // split the obtained list to residencial and commercial list
        final residencial = propertyListingListModel.result.list
            .where((element) => element.propertyDetails.propertyType == PropertyType.RESIDENTIAL)
            .toList();
        final commercial = propertyListingListModel.result.list
            .where((element) => element.propertyDetails.propertyType == PropertyType.COMMERCIAL)
            .toList();

        emit(
          state.copyWith(
            residencialProperties: residencial,
            commercialProperties: commercial,
            totalPropertyCount: propertyListingListModel.result.total,
            status: FormzStatus.submissionSuccess,
          ),
        );
      },
    );
  }
}
