part of 'signup_form_bloc.dart';

abstract class SignupFormEvent extends Equatable {
  const SignupFormEvent();

  @override
  List<Object?> get props => [];
}

class SignupFormChanged extends SignupFormEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String phoneNumber;
  final bool phoneValid;

  SignupFormChanged(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.gender,
      required this.phoneNumber,
      required this.phoneValid});

  @override
  List<Object?> get props => [...super.props, firstName, lastName, email, gender, phoneNumber];
}

class SignupFormButtonClicked extends SignupFormEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String phoneNumber;

  SignupFormButtonClicked(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.gender,
      required this.phoneNumber});

  @override
  List<Object?> get props => [...super.props, firstName, lastName, email, gender, phoneNumber];
}
