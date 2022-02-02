part of 'community_cubit.dart';

class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object> get props => [];
}

class CommunityInit extends CommunityState {
  const CommunityInit();
}

// GET Community main list
//Loading
class LCommunityGuidelines extends CommunityState {
  const LCommunityGuidelines();
}

//Failed
class FCommunityGuidelines extends CommunityState {
  final Failure failure;
  const FCommunityGuidelines({required this.failure});
}

//Success
class SCommunityGuidelines extends CommunityState {
  final List<EmiratesModel> result;
  const SCommunityGuidelines({required this.result});
}

// GET community detail
//Loading
class LCommunityDetails extends CommunityState {
  const LCommunityDetails();
}

//Failed
class FCommunityDetails extends CommunityState {
  final Failure failure;
  const FCommunityDetails({required this.failure});
}

//Success
class SCommunityDetails extends CommunityState {
  final CommunityDetailModel result;
  const SCommunityDetails({required this.result});
}
