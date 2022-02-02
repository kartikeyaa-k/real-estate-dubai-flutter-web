class TimeSlotModel {
  String fromTime;
  String toTime;
  int timeSlotId;
  String day;

  TimeSlotModel(
      {required this.fromTime,
      required this.toTime,
      required this.timeSlotId,
      required this.day});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
        fromTime: json['from_time'],
        toTime: json['to_time'],
        timeSlotId: json['time_slot_id'],
        day: json['day']);
  }
}
