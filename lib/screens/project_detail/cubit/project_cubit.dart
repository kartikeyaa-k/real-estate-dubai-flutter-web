import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/models/request_models/book_status_request_model.dart';
import 'package:real_estate_portal/models/response_models/book_status_response_models/book_status_response_model.dart';
import 'package:real_estate_portal/services/book_status_services/book_status_services.dart';

import '../../../models/project_model/project_model.dart';
import '../../../models/property_details_models/property_location_detail_model.dart';
import '../../../services/project_services/project_services.dart';
import '../../../services/property_services/property_services.dart';

part 'project_state.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  ProjectServices _projectServices;
  PropertyServices _propertyServices;

  ProjectDetailCubit({required ProjectServices projectServices, required PropertyServices propertyServices})
      : _projectServices = projectServices,
        _propertyServices = propertyServices,
        super(ProjectDetailState());

  /*--------------------------------------------*/

  void initPropertyPage(String propertyId) async {
    emit(state.copyWith(
        projectDetailStatus: FormzStatus.submissionInProgress,
        locationDetailStatus: FormzStatus.submissionInProgress,
        bookStatus: FormzStatus.submissionInProgress));

    // load property details
    final projectEither = await _projectServices.getProjectById(projectId: propertyId);

    projectEither.fold(
      (failure) {
        emit(state.copyWith(projectDetailStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (propertyData) {
        String bannerImage = propertyData.projectImages.firstWhere((image) => image.isCover).link;
        // pick the first non cover image
        String sideImageUrl1 = propertyData.projectImages
            .firstWhere((element) => !element.isCover, orElse: () => propertyData.projectImages[0])
            .link;
        String sideImageUrl2 =
            propertyData.projectImages.lastWhere((element) => !element.isCover, orElse: () => propertyData.projectImages[0]).link;

        emit(state.copyWith(
          projectDetailStatus: FormzStatus.submissionSuccess,
          projectData: propertyData,
          coverImage: bannerImage,
          sideImageUrl1: sideImageUrl1,
          sideImageUrl2: sideImageUrl2,
        ));
      },
    );

    // load location details
    final propertyLocationDetailEither = await _propertyServices.getPropertyLocationDetails(state.projectData.location);

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

  @override
  void onChange(Change<ProjectDetailState> change) {
    super.onChange(change);
  }
}
