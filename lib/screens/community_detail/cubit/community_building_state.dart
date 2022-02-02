part of 'community_building_cubit.dart';

class CommunityBuildingState extends Equatable {
  const CommunityBuildingState();

  @override
  List<Object> get props => [];
}

class CommunityBuildingInit extends CommunityBuildingState {
  const CommunityBuildingInit();
}

// GET community building
//Loading
class LCommunityBuildings extends CommunityBuildingState {
  const LCommunityBuildings();
}

//Failed
class FCommunityBuildings extends CommunityBuildingState {
  final Failure failure;
  const FCommunityBuildings({required this.failure});
}

//Success
class SCommunityBuildings extends CommunityBuildingState {
  final List<CommunityBuildingModel> result;
  final int total;
  const SCommunityBuildings({required this.result, required this.total});
}
