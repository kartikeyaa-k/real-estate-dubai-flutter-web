import 'package:equatable/equatable.dart';

class AgencyDetailsModel extends Equatable {
  const AgencyDetailsModel({
    this.agencyId,
    required this.agentName,
    required this.agencyName,
    required this.agentPhone,
    required this.coverImage,
  });

  final int? agencyId;
  final String agentName;
  final String agencyName;
  final String agentPhone;
  final String coverImage;

  static const empty = AgencyDetailsModel(agentName: "", agencyName: "", agentPhone: "", coverImage: "");
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory AgencyDetailsModel.fromJson(Map<String, dynamic> json) => AgencyDetailsModel(
        agencyId: json["agency_id"],
        agentName: json["agent_name"],
        agencyName: json["agency_name"],
        agentPhone: json["agent_phone"],
        coverImage: json["cover_image"],
      );

  Map<String, dynamic> toJson() => {
        "agency_id": agencyId,
        "agent_name": agentName,
        "agency_name": agencyName,
        "agent_phone": agentPhone,
        "cover_image": coverImage,
      };

  @override
  List<Object?> get props => [agencyId, agentName, agencyName, agentPhone, coverImage];
}
