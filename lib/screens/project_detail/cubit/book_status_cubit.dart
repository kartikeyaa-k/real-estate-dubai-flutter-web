/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/book_status_request_model.dart';
import 'package:real_estate_portal/models/request_models/book_time_slot_request_model.dart';
import 'package:real_estate_portal/models/request_models/timeslot_request_model.dart';
import 'package:real_estate_portal/models/response_models/book_status_response_models/book_status_response_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';
import 'package:real_estate_portal/services/book_status_services/book_status_services.dart';
import 'package:real_estate_portal/services/timeslot_services/book_time_slot_services.dart';
import 'package:real_estate_portal/services/timeslot_services/timeslot_services.dart';

part 'book_status_state.dart';

class BookStatusCubit extends Cubit<BookStatusState> {
  BookStatusServices _bookStatusServices;

  BookStatusCubit({required BookStatusServices bookStatusServices})
      : _bookStatusServices = bookStatusServices,
        super(BookStatusInit());

  Future<void> getBookStatus(String projectId) async {
    emit(LBookStatus());

    BookStatusRequestParams requestParams = BookStatusRequestParams(property_id: int.parse(projectId));
    final bookStatusEither = await _bookStatusServices.getBookStatus(requestParam: requestParams);

    bookStatusEither.fold(
      (failure) {
        print('#log : FBookStatus =>');
        print(failure.errorMessage);
        emit(FBookStatus(failure: failure));
      },
      (data) {
        print('#log : SBookStatus => ${data.status}');
        print('#log : SBookStatus :actual price => ${data.actual_price}');
        print('#log : SBookStatus :offered price => ${data.offered_price}');
        emit(SBookStatus(result: data));
      },
    );
  }

  @override
  void onChange(Change<BookStatusState> change) {
    super.onChange(change);
    print(change);
  }
}
