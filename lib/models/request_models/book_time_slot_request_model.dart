class BookTimeSlotRequestParam {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes

  int time_slot_id;
  String date;

  // ignore: non_constant_identifier_names
  BookTimeSlotRequestParam({required this.date, required this.time_slot_id});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['time_slot_id'] = time_slot_id;
    map['date'] = date;
    return map;
  }
}
