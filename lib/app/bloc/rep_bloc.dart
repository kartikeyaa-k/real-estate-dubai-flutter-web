import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_authentication_repository/firebase_authentication_repository.dart';

part 'rep_event.dart';
part 'rep_state.dart';

class RepBloc extends Bloc<RepEvent, RepState> {
  RepBloc({required FirebaseAuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? RepState.authenticated(authenticationRepository.currentUser)
              : const RepState.unauthenticated(),
        ) {
    on<RepUserChanged>(_onUserChanged);
    on<RepLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(RepUserChanged(user)),
    );
  }

  final FirebaseAuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(RepUserChanged event, Emitter<RepState> emit) {
    emit(event.user.isNotEmpty ? RepState.authenticated(event.user) : const RepState.unauthenticated());
  }

  void _onLogoutRequested(RepLogoutRequested event, Emitter<RepState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
