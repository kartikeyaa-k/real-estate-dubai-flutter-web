part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.failureMessage = "",
    this.featureStatus = FormzStatus.pure,
    this.communityStatus = FormzStatus.pure,
    this.projectStatus = FormzStatus.pure,
    this.featureList = FeatureListingModel.empty,
    this.communityListModel = CommunityListModel.empty,
    this.projectListModel = HomeProjectListModel.empty,
  });

  final String failureMessage;
  final FormzStatus featureStatus;
  final FormzStatus communityStatus;
  final FormzStatus projectStatus;
  final FeatureListingModel featureList;
  final CommunityListModel communityListModel;
  final HomeProjectListModel projectListModel;

  @override
  List<Object> get props {
    return [
      failureMessage,
      featureStatus,
      communityStatus,
      projectStatus,
      featureList,
      communityListModel,
      projectListModel,
    ];
  }

  HomeState copyWith({
    String? failureMessage,
    FormzStatus? featureStatus,
    FormzStatus? communityStatus,
    FormzStatus? projectStatus,
    FeatureListingModel? featureList,
    CommunityListModel? communityListModel,
    HomeProjectListModel? projectListModel,
  }) {
    return HomeState(
      failureMessage: failureMessage ?? this.failureMessage,
      featureStatus: featureStatus ?? this.featureStatus,
      communityStatus: communityStatus ?? this.communityStatus,
      projectStatus: projectStatus ?? this.projectStatus,
      featureList: featureList ?? this.featureList,
      communityListModel: communityListModel ?? this.communityListModel,
      projectListModel: projectListModel ?? this.projectListModel,
    );
  }
}
