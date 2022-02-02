class VisitDetailsModel {
  final String? from_time;
  final String? to_time;
  final String? scheduled_date;

  const VisitDetailsModel({this.from_time, this.to_time, this.scheduled_date});

  factory VisitDetailsModel.fromJson(Map<String, dynamic> json) {
    return VisitDetailsModel(from_time: json['from_time'], to_time: json['to_time'], scheduled_date: json['scheduled_date']);
  }
}
