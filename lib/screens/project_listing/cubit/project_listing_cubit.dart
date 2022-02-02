import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/amenity_model.dart';
import '../../../models/home_page_model/suggest_places_model.dart';
import '../../../models/project_model/project_model.dart';
import '../../../services/home/home_services.dart';
import '../../../services/project_services/project_services.dart';

part 'project_listing_state.dart';

class ProjectListingCubit extends Cubit<ProjectListingState> {
  ProjectServices _projectServices;
  HomeServices _homeServices;

  ProjectListingCubit({required ProjectServices projectServices, required HomeServices homeServices})
      : _projectServices = projectServices,
        _homeServices = homeServices,
        super(ProjectListingState());

  /*--------------------------------------------*/

  void initProjectListing({
    List<PlacesResultModel>? placesSearch,
    List<String>? keywords,
    int? deliveryYear,
    int? minPrice,
    int? maxPrice,
    List<int>? amenityIds,
    int? limit,
    int? offset,
    String? sort,
  }) async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      keywords: keywords,
      maxPrice: maxPrice,
      minPrice: minPrice,
      deliveryYear: deliveryYear,
    ));

    final projectEither = await _projectServices.searchProjects(
      keywordArray: keywords,
      locationArray: placesSearch,
      minPrice: minPrice,
      maxPrice: maxPrice,
      amenityIds: amenityIds,
      minYear: deliveryYear,
      limit: limit,
      offset: offset,
      sort: sort,
    );

    projectEither.fold(
      (failure) => emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage)),
      (ProjectListModel projectListModel) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          projectListModel: projectListModel,
          totalProjCount: projectListModel.result.total,
        ));
      },
    );
  }

  void loadAmenities() async {
    final amenitiesEither = await _homeServices.getAmenities();

    amenitiesEither.fold(
      (l) => null,
      (amenities) => emit(state.copyWith(amenities: amenities)),
    );
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
      keywords: null,
      maxPrice: null,
      minPrice: null,
      deliveryYear: null,
      selectedAmenities: null,
    ));
    await _getSearchData();
  }

  /*--------------------------------------------*/

  void clearPriceSection() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    emit(state.clearValues(minPrice: null, maxPrice: null));
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
    final propertyEither = await _projectServices.searchProjects(
      keywordArray: state.keywords,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      amenityIds: state.selectedAmenities.map((e) => e.id).toList(),
      minYear: state.deliveryYear,
    );

    propertyEither.fold(
      (failure) => emit(state.copyWith(failureMessage: failure.errorMessage, status: FormzStatus.submissionFailure)),
      (projectListModel) {
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          projectListModel: projectListModel,
          totalProjCount: projectListModel.result.total,
        ));
      },
    );
  }
}
