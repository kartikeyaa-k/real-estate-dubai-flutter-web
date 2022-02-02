part of 'service_provider_cubit.dart';

class ServiceProviderState extends Equatable {
  const ServiceProviderState();

  @override
  List<Object> get props => [];
}

class ServiceProviderInit extends ServiceProviderState {
  const ServiceProviderInit();
}

// GET SERVICE LIST
//Loading
class LServiceListForFacility extends ServiceProviderState {
  const LServiceListForFacility();
}

//Failed
class FServiceListForFacility extends ServiceProviderState {
  final Failure failure;
  const FServiceListForFacility({required this.failure});
}

//Success
class SServiceListForFacility extends ServiceProviderState {
  final List<ServiceModel> result;
  const SServiceListForFacility({required this.result});
}

// GET SERVICE LIST
//Loading
class LServiceListForOther extends ServiceProviderState {
  const LServiceListForOther();
}

//Failed
class FServiceListForOther extends ServiceProviderState {
  final Failure failure;
  const FServiceListForOther({required this.failure});
}

//Success
class SServiceListForOther extends ServiceProviderState {
  final List<ServiceModel> result;
  const SServiceListForOther({required this.result});
}

// GET ORGANSATION TYPES
//Loading
class LOrganisationTypes extends ServiceProviderState {
  const LOrganisationTypes();
}

//Failed
class FOrganisationTypes extends ServiceProviderState {
  final Failure failure;
  const FOrganisationTypes({required this.failure});
}

//Success
class SOrganisationTypes extends ServiceProviderState {
  final List<OrganisationTypesModel> result;
  const SOrganisationTypes({required this.result});
}

// GET EMIRATES LIST
//Loading
class LEmirateList extends ServiceProviderState {
  const LEmirateList();
}

//Failed
class FEmirateList extends ServiceProviderState {
  final Failure failure;
  const FEmirateList({required this.failure});
}

//Success
class SEmirateList extends ServiceProviderState {
  final List<EmirateModel> result;
  const SEmirateList({required this.result});
}

// ADD SERVICES
//Loading
class LAddService extends ServiceProviderState {
  const LAddService();
}

//Failed
class FAddService extends ServiceProviderState {
  final Failure failure;
  const FAddService({required this.failure});
}

//Success
class SAddService extends ServiceProviderState {
  final AddServiceAgencyResponseModel result;
  const SAddService({required this.result});
}
