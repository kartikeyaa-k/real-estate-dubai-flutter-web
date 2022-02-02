import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/validation_helper.dart';
import '../../../data/http_helper/Ihttp_helper.dart';

part 'signup_form_event.dart';
part 'signup_form_state.dart';

class SignupFormBloc extends Bloc<SignupFormEvent, SignupFormState> {
  final ValidationHelper validationHelper;
  final IHttpHelper httpHelper;
  SignupFormBloc({required this.validationHelper, required this.httpHelper}) : super(SignupFormInitial()) {
    on<SignupFormChanged>(_mapSignupFormChangedToState);
    on<SignupFormButtonClicked>(_mapSignupFormButtonClickedToState);
  }

  /*--------------------------------------------*/

  _mapSignupFormChangedToState(SignupFormChanged event, Emitter emit) {
    bool validateName = validationHelper.validateName(event.firstName);
    bool validateEmail = validationHelper.validateEmail(event.email);
    bool validateGender = event.gender != null && event.gender!.isNotEmpty;
    // bool validatePhoneNumber = isPhoneValid(event.phoneNumber);

    bool formValidation = validateEmail && validateName && validateGender && event.phoneValid;

    if (formValidation)
      emit(SignupFormValidation(disabled: false));
    else
      emit(SignupFormValidation(disabled: true));
  }

  /*--------------------------------------------*/

  _mapSignupFormButtonClickedToState(SignupFormButtonClicked event, Emitter emit) async {
    emit(SignupFormInProgress());

    FirebaseAuth.instance.currentUser?.updateDisplayName("${event.firstName},${event.lastName}");
    var postDetailsEither = await httpHelper.postUserPersonalDetails(
      firstName: event.firstName,
      lastName: event.lastName,
      gender: event.gender ?? "",
      phone: event.phoneNumber,
      email: event.email,
    );

    postDetailsEither.fold(
      (failure) => emit(SignupFormFailure(failureMessage: failure.errorMessage)),
      (success) => emit(SignupFormSucessful()),
    );
  }

  /*--------------------------------------------*/

  @override
  void onEvent(SignupFormEvent event) {
    // print(event);
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<SignupFormEvent, SignupFormState> transition) {
    // print(transition);
    super.onTransition(transition);
  }
}
