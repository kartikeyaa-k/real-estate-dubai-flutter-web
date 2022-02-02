part of 'book_status_cubit.dart';

class BookStatusState extends Equatable {
  const BookStatusState();

  @override
  List<Object> get props => [];
}

class BookStatusInit extends BookStatusState {
  const BookStatusInit();
}

// GET TIME SLOT
//Loading
class LBookStatus extends BookStatusState {
  const LBookStatus();
}

//Failed
class FBookStatus extends BookStatusState {
  final Failure failure;
  const FBookStatus({required this.failure});
}

//Success
class SBookStatus extends BookStatusState {
  final BookStatusResponseModel result;
  const SBookStatus({required this.result});
}
