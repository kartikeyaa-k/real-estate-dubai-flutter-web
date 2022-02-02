part of 'service_main_cubit.dart';

class ServiceMainState extends Equatable {
  const ServiceMainState();

  @override
  List<Object> get props => [];
}

class ServicesMainInit extends ServiceMainState {
  const ServicesMainInit();
}

//Loading
class LOtherServicesMain extends ServiceMainState {
  const LOtherServicesMain();
}

//Failed
class FOtherServicesMain extends ServiceMainState {
  final Failure failure;
  const FOtherServicesMain({required this.failure});
}

//Success
class SOtherServicesMain extends ServiceMainState {
  final List<ServiceMainModel> result;
  const SOtherServicesMain({required this.result});
}

/*--------------------------------------------*/

//Loading
class LFacilityMngServicesMain extends ServiceMainState {
  const LFacilityMngServicesMain();
}

//Failed
class FFacilityMngServicesMain extends ServiceMainState {
  final Failure failure;
  const FFacilityMngServicesMain({required this.failure});
}

//Success
class SFacilityMngServicesMain extends ServiceMainState {
  final List<ServiceMainModel> facilityServiceResult;
  const SFacilityMngServicesMain({required this.facilityServiceResult});
}

/*--------------------------------------------*/

//Loading
class LSubmitServiceEnquiry extends ServiceMainState {
  const LSubmitServiceEnquiry();
}

//Failed
class FSubmitServiceEnquiry extends ServiceMainState {
  final Failure failure;
  const FSubmitServiceEnquiry({required this.failure});
}

//Success
class SSubmitServiceEnquiry extends ServiceMainState {
  const SSubmitServiceEnquiry();
}
