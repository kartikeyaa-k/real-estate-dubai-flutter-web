part of 'signup_form_bloc.dart';

abstract class SignupFormState extends Equatable {
  final bool disabled;
  final bool isLoading;
  final String failureMessage;

  const SignupFormState({this.disabled = true, this.failureMessage = "", this.isLoading = false});

  @override
  List<Object> get props => [disabled, failureMessage, isLoading];
}

class SignupFormInitial extends SignupFormState {}

class SignupFormValidation extends SignupFormState {
  SignupFormValidation({required bool disabled}) : super(disabled: disabled);
}

class SignupFormInProgress extends SignupFormState {
  SignupFormInProgress() : super(isLoading: true, disabled: false);
}

class SignupFormSucessful extends SignupFormState {
  SignupFormSucessful() : super(isLoading: false, disabled: false);
}

class SignupFormFailure extends SignupFormState {
  SignupFormFailure({required String failureMessage})
      : super(failureMessage: failureMessage, disabled: false, isLoading: false);
}
