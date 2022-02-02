part of 'cover_page_cubit.dart';

class CoverPageState extends Equatable {
  const CoverPageState();

  @override
  List<Object> get props => [];
}

class CoverPageInit extends CoverPageState {
  const CoverPageInit();
}

// GET COVER PAGE
//Loading
class LCoverPage extends CoverPageState {
  const LCoverPage();
}

//Failed
class FCoverPage extends CoverPageState {
  final Failure failure;
  const FCoverPage({required this.failure});
}

//Success
class SCoverPage extends CoverPageState {
  final CoverPageModel coverProjectDetails;
  final ProjectModel otherDetails;
  const SCoverPage({required this.coverProjectDetails, required this.otherDetails});
}

// GET LOCATION PAGE
//Loading
class LLocationDetail extends CoverPageState {
  const LLocationDetail();
}

//Failed
class FLocationDetail extends CoverPageState {
  final Failure failure;
  const FLocationDetail({required this.failure});
}

//Success
class SLocationDetail extends CoverPageState {
  final PropertyLocationDetailModel propertyLocationDetailModel;
  const SLocationDetail({required this.propertyLocationDetailModel});
}
