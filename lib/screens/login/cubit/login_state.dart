part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = "",
    this.isNewUser = false,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final bool isNewUser;

  @override
  List<Object?> get props => [email, password, status, errorMessage, isNewUser];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    bool? isNewUser,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
