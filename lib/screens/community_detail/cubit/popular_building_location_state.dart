part of 'popular_building_location_cubit.dart';

class PopularBuildingLocationState extends Equatable {
  const PopularBuildingLocationState();

  @override
  List<Object> get props => [];
}

class PopularBuildingLocationInit extends PopularBuildingLocationState {
  const PopularBuildingLocationInit();
}

//Loading
class LPopularBuildingLocations extends PopularBuildingLocationState {
  const LPopularBuildingLocations();
}

//Failed
class FPopularBuildingLocations extends PopularBuildingLocationState {
  final Failure failure;
  const FPopularBuildingLocations({required this.failure});
}

//Success
class SPopularBuildingLocations extends PopularBuildingLocationState {
  final PopularBuildingLocationResponseModel? result;
  const SPopularBuildingLocations({required this.result});
}
