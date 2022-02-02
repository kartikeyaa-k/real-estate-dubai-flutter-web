import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failure.dart';
import '../../../models/request_models/get_services_main_model.dart';
import '../../../models/request_models/service_enquire_request_model.dart';
import '../../../models/response_models/services_main_response_models/get_services_main_response_model.dart';
import '../../../services/services_main_services/services_main_service.dart';

part 'service_main_state.dart';

class ServiceMainCubit extends Cubit<ServiceMainState> {
  ServicesMainService _servicesMainService;

  ServiceMainCubit({required ServicesMainService servicesMainService})
      : _servicesMainService = servicesMainService,
        super(ServicesMainInit());

  Future<void> getOtherServices() async {
    emit(LOtherServicesMain());
    GetServicesMainRequestModel requestModel = GetServicesMainRequestModel(service_type: "OTHER_SERVICE");
    final responseEither = await _servicesMainService.getServiceList(requestParam: requestModel);

    responseEither.fold(
      (failure) {
        print('#log : FServicesMain for other services =>');
        print(failure.errorMessage);
        emit(FOtherServicesMain(failure: failure));
      },
      (data) {
        // print('#log : SCommunityGuidelines => ${data.result}');
        emit(SOtherServicesMain(result: data.result));
      },
    );

    emit(LFacilityMngServicesMain());
    GetServicesMainRequestModel requestModel1 =
        GetServicesMainRequestModel(service_type: "FACILITY_MANAGEMENT_SERVICE");
    final responseEither1 = await _servicesMainService.getServiceList(requestParam: requestModel1);

    responseEither1.fold(
      (failure) {
        print('#log : FServicesMain facility error =>');
        print(failure.errorMessage);
        emit(FFacilityMngServicesMain(failure: failure));
      },
      (data) {
        emit(SFacilityMngServicesMain(facilityServiceResult: data.result));
      },
    );
  }

  Future<void> getFacilityMngServices() async {
    emit(LFacilityMngServicesMain());
    GetServicesMainRequestModel requestModel = GetServicesMainRequestModel(service_type: "FACILITY_MANAGEMENT_SERVICE");
    final responseEither = await _servicesMainService.getServiceList(requestParam: requestModel);

    responseEither.fold(
      (failure) {
        print('#log : FServicesMain facility error =>');
        print(failure.errorMessage);
        emit(FFacilityMngServicesMain(failure: failure));
      },
      (data) {
        emit(SFacilityMngServicesMain(facilityServiceResult: data.result));
      },
    );
  }

  Future<void> submitEnquiry({required ServiceEnquireRequestParams requestParams}) async {
    emit(LSubmitServiceEnquiry());
    final responseEither = await _servicesMainService.submitEnquiry(requestParam: requestParams);

    responseEither.fold(
      (failure) {
        print('#log : FSubmitServiceEnquiry =>');
        print(failure.errorMessage);
        emit(FSubmitServiceEnquiry(failure: failure));
      },
      (data) {
        emit(SSubmitServiceEnquiry());
      },
    );
  }
}
