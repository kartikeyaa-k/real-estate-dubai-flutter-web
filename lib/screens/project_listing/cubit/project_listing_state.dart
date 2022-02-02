part of 'project_listing_cubit.dart';

class ProjectListingState extends Equatable {
  const ProjectListingState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
    this.projectListModel = ProjectListModel.empty,
    this.amenities = const [],
    this.minPrice,
    this.maxPrice,
    this.deliveryYear,
    this.selectedAmenities = const [],
    this.keywords = const [],
    this.totalProjCount = 1,
  });

  final FormzStatus status;
  final String failureMessage;
  final ProjectListModel projectListModel;
  final List<AmenityModel> amenities;

  // Price attributes
  final int? minPrice;
  final int? maxPrice;
  // project status
  final int? deliveryYear;
  // amenities attributes
  final List<AmenityModel> selectedAmenities;

  final List<String> keywords;
  final int totalProjCount;

  @override
  List<Object?> get props {
    return [
      status,
      failureMessage,
      projectListModel,
      amenities,
      minPrice,
      maxPrice,
      deliveryYear,
      selectedAmenities,
      keywords,
      totalProjCount,
    ];
  }

  ProjectListingState clearValues({
    int? deliveryYear,
    int? minPrice,
    int? maxPrice,
    List<String>? keywords,
    List<AmenityModel>? selectedAmenities,
    int? totalProjCount,
  }) {
    return ProjectListingState(
        // keep these attributes constant when cleared
        status: status,
        failureMessage: failureMessage,
        amenities: amenities,

        // changable attributes when cleared
        deliveryYear: deliveryYear,
        minPrice: minPrice,
        maxPrice: maxPrice,
        keywords: keywords ?? [],
        selectedAmenities: selectedAmenities ?? [],
        totalProjCount: totalProjCount ?? 1);
  }

  ProjectListingState copyWith({
    FormzStatus? status,
    String? failureMessage,
    ProjectListModel? projectListModel,
    List<AmenityModel>? amenities,
    int? minPrice,
    int? maxPrice,
    int? deliveryYear,
    List<AmenityModel>? selectedAmenities,
    List<String>? keywords,
    int? totalProjCount,
  }) {
    return ProjectListingState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      projectListModel: projectListModel ?? this.projectListModel,
      amenities: amenities ?? this.amenities,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      deliveryYear: deliveryYear ?? this.deliveryYear,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      keywords: keywords ?? this.keywords,
      totalProjCount: totalProjCount ?? this.totalProjCount,
    );
  }
}
