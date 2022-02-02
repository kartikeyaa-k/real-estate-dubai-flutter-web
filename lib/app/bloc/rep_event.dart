part of 'rep_bloc.dart';

abstract class RepEvent extends Equatable {
  const RepEvent();

  @override
  List<Object> get props => [];
}

class RepLogoutRequested extends RepEvent {}

class RepUserChanged extends RepEvent {
  const RepUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
