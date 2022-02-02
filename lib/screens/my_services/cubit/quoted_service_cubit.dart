import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/models/response_models/my_service_models/quoted_service_model.dart';

import '../../../models/response_models/my_service_models/requested_service_model.dart';
import '../../../services/my_services/my_services_service.dart';

part 'quoted_service_state.dart';

class QuotedServiceCubit extends Cubit<QuotedServiceState> {
  QuotedServiceCubit(this.myServicesService) : super(QuotedServiceState());

  final MyServicesService myServicesService;

  loadQuoutedService() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final responseEither = await myServicesService.getQuotedServices();

    responseEither.fold(
      (failure) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (requestedService) {
        emit(
          state.copyWith(status: FormzStatus.submissionSuccess, services: requestedService.data),
        );
      },
    );
  }
}
