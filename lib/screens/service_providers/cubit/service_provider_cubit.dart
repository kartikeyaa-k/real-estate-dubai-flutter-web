/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/add_service_agency_model.dart';
import 'package:real_estate_portal/models/request_models/service_list_request_model.dart';
import 'package:real_estate_portal/models/response_models/emirate_list_models/emirate_model.dart';
import 'package:real_estate_portal/models/response_models/organisation_types_models/organisation_types_model.dart';
import 'package:real_estate_portal/models/response_models/service_list_models/add_service_agency_response_model.dart';
import 'package:real_estate_portal/models/response_models/service_list_models/service_model.dart';
import 'package:real_estate_portal/services/service_provider_service/service_provider_services.dart';

part 'service_provider_state.dart';

class ServiceProviderCubit extends Cubit<ServiceProviderState> {
  ServiceProviderServices _serviceProviderServices;

  ServiceProviderCubit({required ServiceProviderServices serviceProviderServices})
      : _serviceProviderServices = serviceProviderServices,
        super(ServiceProviderInit());

  Future<void> getServiceListForFacility() async {
    emit(LServiceListForFacility());

    ServiceListRequestParams requestParams = ServiceListRequestParams(service_type: 'FACILITY_MANAGEMENT_SERVICE');
    final serviceListtEither = await _serviceProviderServices.getServiceList(requestParam: requestParams);

    serviceListtEither.fold(
      (failure) {
        print('#log : FServiceList =>');
        print(failure.errorMessage);
        emit(FServiceListForFacility(failure: failure));
      },
      (data) {
        print('#log : SServiceListForFacility => ${data.status}');
        emit(SServiceListForFacility(result: data.result ?? []));
      },
    );
  }

  Future<void> getServiceListForOther() async {
    emit(LServiceListForOther());

    ServiceListRequestParams requestParams = ServiceListRequestParams(service_type: 'OTHER_SERVICE');
    final serviceListtEither = await _serviceProviderServices.getServiceList(requestParam: requestParams);

    serviceListtEither.fold(
      (failure) {
        print('#log : FServiceListForOther =>');
        print(failure.errorMessage);
        emit(FServiceListForOther(failure: failure));
      },
      (data) {
        print('#log : SServiceListForOther => ${data.status}');
        emit(SServiceListForOther(result: data.result ?? []));
      },
    );
  }

  Future<void> getOrganisationTypesList() async {
    emit(LOrganisationTypes());

    final organisationTypesEither = await _serviceProviderServices.getOrganisationTypes();

    organisationTypesEither.fold(
      (failure) {
        print('#log : FOrganisationTypes =>');
        print(failure.errorMessage);
        emit(FOrganisationTypes(failure: failure));
      },
      (data) {
        print('#log : SOrganisationTypes => ${data.success}');
        emit(SOrganisationTypes(result: data.list ?? []));
      },
    );
  }

  Future<void> getEmiratesList() async {
    emit(LEmirateList());

    final emirateListEither = await _serviceProviderServices.getEmirateList();

    emirateListEither.fold(
      (failure) {
        print('#log : FEmirateList => ${failure.errorMessage}');
        print(failure.errorMessage);
        emit(FEmirateList(failure: failure));
      },
      (data) {
        print('#log : SEmirateList => ${data.success}');
        emit(SEmirateList(result: data.data ?? []));
      },
    );
  }

  Future<void> addServiceAgency(AddServiceAgencyRequestParams requestParams) async {
    emit(LAddService());

    final addServiceaAgencyEither = await _serviceProviderServices.addServiceAgency(requestParams: requestParams);

    addServiceaAgencyEither.fold(
      (failure) {
        print('#log : FAddService => ${failure.errorMessage}');
        print(failure.errorMessage);
        emit(FAddService(failure: failure));
      },
      (data) {
        print('#log : SAddService => ${data}');
        emit(SAddService(result: data));
      },
    );
  }
}
