import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/services/my_services/my_services_service.dart';

import '../../../models/request_models/get_services_main_model.dart';
import '../../../models/response_models/services_main_response_models/get_services_main_response_model.dart';
import '../../../services/services_main_services/services_main_service.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServicesMainService servicesMainService;
  final MyServicesService myServicesService;

  ServiceCubit({required this.servicesMainService, required this.myServicesService}) : super(ServiceState());

  Future<void> getOtherServices() async {
    emit(state.copyWith(otherServiceStatus: FormzStatus.submissionInProgress));
    GetServicesMainRequestModel requestModel = GetServicesMainRequestModel(service_type: "OTHER_SERVICE");
    final responseEither = await servicesMainService.getServiceList(requestParam: requestModel);

    responseEither.fold(
      (failure) {
        emit(state.copyWith(otherServiceStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (data) {
        emit(state.copyWith(otherServiceStatus: FormzStatus.submissionSuccess, otherServices: data.result));
      },
    );
  }

  Future<void> getFacilityMngServices() async {
    emit(state.copyWith(facilityServiceStatus: FormzStatus.submissionInProgress));
    GetServicesMainRequestModel requestModel = GetServicesMainRequestModel(service_type: "FACILITY_MANAGEMENT_SERVICE");
    final responseEither = await servicesMainService.getServiceList(requestParam: requestModel);

    responseEither.fold(
      (failure) {
        emit(
            state.copyWith(facilityServiceStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (data) {
        emit(state.copyWith(facilityServiceStatus: FormzStatus.submissionSuccess, facilityServices: data.result));
      },
    );
  }

  Future<void> createRequest({required int propertyId, required int serviceId}) async {
    emit(state.copyWith(serviceRequestStatus: FormzStatus.submissionInProgress));

    final responseEither =
        await myServicesService.createTenantServiceRequest(propertyId: propertyId, serviceId: serviceId);

    responseEither.fold(
      (failure) => emit(
          state.copyWith(serviceRequestStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage)),
      (result) => emit(state.copyWith(serviceRequestStatus: FormzStatus.submissionSuccess)),
    );
  }
}
