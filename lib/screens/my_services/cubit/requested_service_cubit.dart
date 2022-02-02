import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/services/my_services/my_services_service.dart';

import '../../../models/response_models/my_service_models/requested_service_model.dart';

part 'requested_service_state.dart';

class RequestedServiceCubit extends Cubit<RequestedServiceState> {
  RequestedServiceCubit(this.myServicesService) : super(RequestedServiceState());

  final MyServicesService myServicesService;

  loadRequestedServiceCubit() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final responseEither = await myServicesService.getRequestedServices();

    responseEither.fold(
      (failure) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (requestedService) {
        emit(
          state.copyWith(status: FormzStatus.submissionSuccess, requestedServices: requestedService.data),
        );
      },
    );
  }
}
