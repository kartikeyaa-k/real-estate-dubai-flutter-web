import 'package:intl/intl.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';

List<TimeSlotModel> setWeekday({required String weekday, required List<TimeSlotModel> list}) {
  List<TimeSlotModel> result = list.where((i) => i.day == weekday).toList();

  return result;
}

String appDateFormatter(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(date);
  return formatted;
}
