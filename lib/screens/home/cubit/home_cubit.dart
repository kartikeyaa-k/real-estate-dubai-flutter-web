import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../models/home_page_model/community_list_model.dart';
import '../../../models/home_page_model/feature_list_model.dart';
import '../../../models/home_page_model/project_list_model.dart';
import '../../../services/home/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeServices _homeServices;

  HomeCubit({required HomeServices homeServices})
      : _homeServices = homeServices,
        super(HomeState());

  void initHomeScreen() async {
    emit(
      state.copyWith(
        featureStatus: FormzStatus.submissionInProgress,
        communityStatus: FormzStatus.submissionInProgress,
        projectStatus: FormzStatus.submissionInProgress,
      ),
    );

    final featureEither = await _homeServices.getFeaturedProperties();

    featureEither.fold(
      (failure) =>
          emit(state.copyWith(failureMessage: failure.errorMessage, featureStatus: FormzStatus.submissionFailure)),
      (featureListing) =>
          emit(state.copyWith(featureStatus: FormzStatus.submissionSuccess, featureList: featureListing)),
    );

    final communityEither = await _homeServices.getCommunities();

    communityEither.fold(
      (failure) =>
          emit(state.copyWith(failureMessage: failure.errorMessage, communityStatus: FormzStatus.submissionFailure)),
      (communityListing) =>
          emit(state.copyWith(communityStatus: FormzStatus.submissionSuccess, communityListModel: communityListing)),
    );

    final projectEither = await _homeServices.getProjectList();

    projectEither.fold(
      (failure) =>
          emit(state.copyWith(failureMessage: failure.errorMessage, projectStatus: FormzStatus.submissionFailure)),
      (projectList) =>
          emit(state.copyWith(projectStatus: FormzStatus.submissionSuccess, projectListModel: projectList)),
    );
  }
}
