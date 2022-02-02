import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/property_details_models/property_location_detail_model.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../services/property_services/property_services.dart';

part 'property_state.dart';

class PropertyDetailCubit extends Cubit<PropertyDetailState> {
  PropertyServices _propertyServices;
  PropertyDetailCubit(this._propertyServices) : super(PropertyDetailState());

  /*--------------------------------------------*/

  void initPropertyPage(String propertyId) async {
    emit(
      state.copyWith(
        propertyDetailStatus: FormzStatus.submissionInProgress,
        locationDetailStatus: FormzStatus.submissionInProgress,
      ),
    );

    // load property details

    final propertyEither = await _propertyServices.getPropertyById(propertyId);

    propertyEither.fold(
      (failure) {
        emit(state.copyWith(propertyDetailStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (propertyData) {
        String bannerImage = propertyData.propertyImages
            .firstWhere((image) => image.isCover, orElse: () => propertyData.propertyImages[0])
            .link;
        // pick the first non cover image
        String sideImageUrl1 = propertyData.propertyImages
            .firstWhere((element) => !element.isCover, orElse: () => propertyData.propertyImages[0])
            .link;
        String sideImageUrl2 = propertyData.propertyImages
            .lastWhere((element) => !element.isCover, orElse: () => propertyData.propertyImages[0])
            .link;

        emit(state.copyWith(
          propertyDetailStatus: FormzStatus.submissionSuccess,
          propertyData: propertyData,
          coverImage: bannerImage,
          sideImageUrl1: sideImageUrl1,
          sideImageUrl2: sideImageUrl2,
        ));
      },
    );

    // load property bookmark status

    final bookmarkEither = await _propertyServices.checkPropertyBookmarkStatus(propertyId);
    bookmarkEither.fold(
      (failure) => emit(state.copyWith(isBookmarked: false)),
      (success) => emit(state.copyWith(isBookmarked: success)),
    );

    // load location details
    final propertyLocationDetailEither =
        await _propertyServices.getPropertyLocationDetails(state.propertyData.propertyDetails.location);

    propertyLocationDetailEither.fold(
      (failure) {
        emit(state.copyWith(locationDetailStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (locationData) {
        emit(state.copyWith(locationDetailStatus: FormzStatus.submissionSuccess, propertyLocationDetail: locationData));
      },
    );
  }

  /*--------------------------------------------*/

  void bookmarkProperty() async {
    final bookmarkEither = await _propertyServices.bookmarkProperty(state.propertyData.propertyDetails.id.toString());
    bookmarkEither.fold(
      (failure) => emit(state.copyWith(isBookmarked: false)),
      (success) => emit(state.copyWith(isBookmarked: !state.isBookmarked)),
    );
  }

  @override
  void onChange(Change<PropertyDetailState> change) {
    super.onChange(change);
  }
}
