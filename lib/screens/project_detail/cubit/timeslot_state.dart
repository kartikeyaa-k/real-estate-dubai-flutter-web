/* Written by : Kartikeya
any questions => write file_no = 3, line_no,  followed by question
 */

part of 'timeslot_cubit.dart';

class TimeSlotState extends Equatable {
  const TimeSlotState();

  @override
  List<Object> get props => [];
}

class TimeSlotInit extends TimeSlotState {
  const TimeSlotInit();
}

// GET TIME SLOT
//Loading
class LTimeSlot extends TimeSlotState {
  const LTimeSlot();
}

//Failed
class FTimeSlot extends TimeSlotState {
  final Failure failure;
  const FTimeSlot({required this.failure});
}

//Success
class STimeSlot extends TimeSlotState {
  final List<TimeSlotModel>? result;
  const STimeSlot({this.result});
}

// BOOK TIME SLOT
//Loading
class LBookTimeSlot extends TimeSlotState {
  const LBookTimeSlot();
}

//Failed
class FBookTimeSlot extends TimeSlotState {
  final Failure failure;
  const FBookTimeSlot({required this.failure});
}

//Success
class SBookTimeSlot extends TimeSlotState {
  const SBookTimeSlot();
}
