/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/book_time_slot_request_model.dart';
import 'package:real_estate_portal/models/request_models/timeslot_request_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';
import 'package:real_estate_portal/services/timeslot_services/book_time_slot_services.dart';
import 'package:real_estate_portal/services/timeslot_services/timeslot_services.dart';

part 'timeslot_state.dart';

class TimeSlotCubit extends Cubit<TimeSlotState> {
  TimeSlotServices _timeSlotServices;
  BookTimeSlotServices _bookTimeSlotServices;

  TimeSlotCubit({required TimeSlotServices timeSlotServices, required BookTimeSlotServices bookTimeSlotServices})
      : _timeSlotServices = timeSlotServices,
        _bookTimeSlotServices = bookTimeSlotServices,
        super(TimeSlotInit());

  Future<void> getTimeSlot(int projectId) async {
    emit(LTimeSlot());

    TimeSlotRequestParam requestParam = TimeSlotRequestParam(property_id: projectId);
    final timeslot = await _timeSlotServices.getTimeSlots(requestParam: requestParam);

    timeslot.fold(
      (failure) {
        print('#log : FTimeSlot =>');
        print(failure.errorMessage);
        emit(FTimeSlot(failure: failure));
      },
      (data) {
        print('#log :====================> `STimeSlot => ${data.data?.map((e) => e.day)}');
        emit(STimeSlot(result: data.data));
      },
    );
  }

  Future<void> bookTimeSlot({required String date, required int time_slot_id}) async {
    emit(LBookTimeSlot());

    BookTimeSlotRequestParam requestParam = BookTimeSlotRequestParam(time_slot_id: time_slot_id, date: date);
    final timeslot = await _bookTimeSlotServices.bookTimeSlot(requestParam: requestParam);

    timeslot.fold(
      (failure) {
        print('#log : FBookTimeSlot =>');
        print(failure.errorMessage);
        emit(FBookTimeSlot(failure: failure));
      },
      (data) {
        print('#log : SBookTimeSlot => ${data.success}');
        emit(SBookTimeSlot());
      },
    );
  }
}
