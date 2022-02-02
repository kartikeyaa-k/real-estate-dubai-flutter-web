part of 'rep_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class RepState extends Equatable {
  const RepState._({
    required this.status,
    this.user = User.empty,
  });

  const RepState.authenticated(User user) : this._(status: AppStatus.authenticated, user: user);

  const RepState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [];
}
