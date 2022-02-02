class BookedTimeSlotResponseModel {
  bool success;

  BookedTimeSlotResponseModel({
    required this.success,
  });

  factory BookedTimeSlotResponseModel.fromJson(Map<String, dynamic> json) {
    return BookedTimeSlotResponseModel(
      success: json['success'],
    );
  }
}
