part of 'my_properties_cubit.dart';

class MyPropertiesState extends Equatable {
  const MyPropertiesState();

  @override
  List<Object> get props => [];
}

class MyPropertiesInit extends MyPropertiesState {
  const MyPropertiesInit();
}

//* Booked
//Loading
class LBooked extends MyPropertiesState {
  const LBooked();
}

//Failed
class FBooked extends MyPropertiesState {
  final Failure failure;
  const FBooked({required this.failure});
}

//Success
class SBooked extends MyPropertiesState {
  final BookedPropertiesResponseModel result;
  const SBooked({required this.result});
}


//* In Process
//Loading
class LInProcess extends MyPropertiesState {
  const LInProcess();
}

//Failed
class FInProcess extends MyPropertiesState {
  final Failure failure;
  const FInProcess({required this.failure});
}

//Success
class SInProcess extends MyPropertiesState {
  final BookedPropertiesResponseModel result;
  const SInProcess({required this.result});
}

//* Saved
//Loading
class LSaved extends MyPropertiesState {
  const LSaved();
}

//Failed
class FSaved extends MyPropertiesState {
  final Failure failure;
  const FSaved({required this.failure});
}

//Success
class SSaved extends MyPropertiesState {
  final BookedPropertiesResponseModel result;
  const SSaved({required this.result});
}