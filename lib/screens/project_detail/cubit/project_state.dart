part of 'project_cubit.dart';

class ProjectDetailState extends Equatable {
  const ProjectDetailState({
    this.projectDetailStatus = FormzStatus.pure,
    this.locationDetailStatus = FormzStatus.pure,
    this.bookStatus = FormzStatus.pure,
    this.failureMessage = "",
    this.projectData = ProjectModel.empty,
    this.propertyLocationDetail = PropertyLocationDetailModel.empty,
    this.bookStatusResponseModel = BookStatusResponseModel.empty,
    this.coverImage = "",
    this.sideImageUrl1 = "",
    this.sideImageUrl2 = "",
  });

  final FormzStatus projectDetailStatus;
  final FormzStatus locationDetailStatus;
  final FormzStatus bookStatus;
  final String failureMessage;
  final ProjectModel projectData;
  final PropertyLocationDetailModel propertyLocationDetail;
  final BookStatusResponseModel bookStatusResponseModel;
  final String coverImage;
  final String sideImageUrl1;
  final String sideImageUrl2;

  @override
  List<Object> get props {
    return [
      projectDetailStatus,
      locationDetailStatus,
      bookStatus,
      failureMessage,
      projectData,
      propertyLocationDetail,
      bookStatusResponseModel,
      coverImage,
      sideImageUrl1,
      sideImageUrl2,
    ];
  }

  ProjectDetailState copyWith({
    FormzStatus? projectDetailStatus,
    FormzStatus? locationDetailStatus,
    FormzStatus? bookStatus,
    String? failureMessage,
    ProjectModel? projectData,
    PropertyLocationDetailModel? propertyLocationDetail,
    BookStatusResponseModel? bookStatusResponseModel,
    String? coverImage,
    String? sideImageUrl1,
    String? sideImageUrl2,
  }) {
    return ProjectDetailState(
      projectDetailStatus: projectDetailStatus ?? this.projectDetailStatus,
      locationDetailStatus: locationDetailStatus ?? this.locationDetailStatus,
      bookStatus: bookStatus ?? this.bookStatus,
      failureMessage: failureMessage ?? this.failureMessage,
      projectData: projectData ?? this.projectData,
      propertyLocationDetail: propertyLocationDetail ?? this.propertyLocationDetail,
      bookStatusResponseModel: bookStatusResponseModel ?? this.bookStatusResponseModel,
      coverImage: coverImage ?? this.coverImage,
      sideImageUrl1: sideImageUrl1 ?? this.sideImageUrl1,
      sideImageUrl2: sideImageUrl2 ?? this.sideImageUrl2,
    );
  }
}
