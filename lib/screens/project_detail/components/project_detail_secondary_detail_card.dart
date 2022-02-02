import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/amenity_model.dart';
import '../../../models/property_details_models/property_location_detail_model.dart';

class ProjectDetailSecondaryDetailCard extends StatelessWidget {
  const ProjectDetailSecondaryDetailCard({
    Key? key,
    required this.globalKey,
    required this.startingPrice,
    required this.totalUnits,
    this.deliveryDate,
    this.amenities,
    this.additionalFeatures,
    required this.description,
    this.position,
    required this.locationDetails,
  }) : super(key: key);
  final GlobalKey globalKey;
  final String? startingPrice;
  final String totalUnits;
  final DateTime? deliveryDate;
  final List<AmenityModel>? amenities;
  final List<AmenityModel>? additionalFeatures;
  final String description;
  final LatLng? position;
  final PropertyLocationDetailModel locationDetails;

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = Responsive.isMobile(context) ? SizedBox(height: Insets.med) : SizedBox(height: Insets.lg);
    Widget _lgVSpace = Responsive.isMobile(context) ? Container(height: Insets.med) : SizedBox(height: Insets.xxl);

    // Propery Details Section
    List<Widget> _details = [
      _propertyDetailRow(title: "Price From:", value: startingPrice != null ? "AED $startingPrice" : "TBD"),
      _propertyDetailRow(title: "Total Units:", value: totalUnits),
      if (deliveryDate != null)
        _propertyDetailRow(title: "Delivery Date:", value: DateFormat("yMMM").format(deliveryDate!)),
    ];

    Widget _propertyDetailTitle =
        Text("Project Detail:", style: TextStyles.h2.copyWith(color: kBlackVariant), key: globalKey);

    List<Widget> _propertyDetailMobile = [
      _propertyDetailTitle,
      _vSpace,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [..._details],
      )
    ];

    List<Widget> _propertyDetail = [
      _propertyDetailTitle,
      _vSpace,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [..._details.sublist(0, 2)],
            ),
          ),
          Expanded(
            child: Column(
              children: [..._details.sublist(2)],
            ),
          )
        ],
      )
    ];

    // Amenities
    List<Widget> _amenities = [
      Text("Amenities", style: TextStyles.h2.copyWith(color: kBlackVariant)),
      _vSpace,
      amenities == null
          ? Container()
          : Wrap(
              spacing: Insets.med,
              children: amenities!.map((e) => _amenitiesRow(title: e.name.en, icon: e.logo)).toList(),
            ),
    ];

    // additional features
    List<Widget> _additionalFeatures = [
      Text("Additional Features", style: TextStyles.h2.copyWith(color: kBlackVariant)),
      _vSpace,
      additionalFeatures == null
          ? Container()
          : Wrap(
              spacing: Insets.med,
              children: additionalFeatures!.map((e) => _amenitiesRow(title: e.name.en, icon: e.logo)).toList(),
            ),
    ];

    // Description
    List<Widget> _description = [
      Text("Description:", style: TextStyles.h2.copyWith(color: kBlackVariant)),
      _vSpace,
      Text(
        description,
        style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
      )
    ];

    // Location
    Widget _locationDetails = Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: Insets.med,
            runSpacing: Insets.xl,
            children: [
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_hospital_outlined, color: kSupportBlue),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text("Closest Hospital (${locationDetails.distanceHospital})", style: TextStyles.body18))
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus_outlined, color: kSupportBlue),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text("Closest Bus Station (${locationDetails.distanceBusStation})",
                            style: TextStyles.body18))
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school_outlined, color: kSupportBlue),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text("Closest School (${locationDetails.distanceSchool})", style: TextStyles.body18))
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flight_outlined, color: kSupportBlue),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text("Closest Airport (${locationDetails.distanceAirport})", style: TextStyles.body18))
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_transit_filled_outlined, color: kSupportBlue),
                    SizedBox(width: 10),
                    Flexible(
                        child: Text("Closest Train Station (${locationDetails.distanceTrainStation})",
                            style: TextStyles.body18))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    List<Widget> _mapView = [
      Text(
        "Location:",
        style: TextStyles.h2.copyWith(color: kBlackVariant),
      ),
      _vSpace,
      // map view
      AspectRatio(
        aspectRatio: Responsive.isDesktop(context) ? 710 / 400 : 360 / 202,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: position ?? LatLng(15.3982, 73.8113), zoom: 14),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Center(
                child: PrimaryButton(
                  onTap: () {
                    context.vRouter.toExternal(
                        "https://maps.google.com?q=${position?.latitude ?? 15.3982},${position?.longitude ?? 73.8113}",
                        openNewTab: true);
                  },
                  text: "Get directions",
                  width: 115,
                ),
              ),
            ),
          ],
        ),
      ),
      _vSpace,
      _locationDetails
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: Corners.lgBorder),
      padding: EdgeInsets.all(Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...Responsive.isMobile(context) ? _propertyDetailMobile : _propertyDetail,
          _lgVSpace,
          ..._amenities,
          _lgVSpace,
          ..._additionalFeatures,
          _lgVSpace,
          ..._description,
          _lgVSpace,
          ..._mapView,
        ],
      ),
    );
  }

  Widget _propertyDetailRow({required String title, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.xl),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyles.body18.copyWith(color: kBlackVariant))),
          Expanded(
            child: Text(value, style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7))),
          )
        ],
      ),
    );
  }

  Widget _amenitiesRow({
    required String title,
    String? icon,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: 200, height: 56),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.network(icon ?? ""),
          ),
          SizedBox(width: Insets.lg),
          Flexible(
            child: Text(
              title,
              style: TextStyles.h3.copyWith(color: kDarkGrey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

final locationArray = [
  LocationDetails(Icons.local_hospital_outlined, "Closest Hospital(2Km)"),
  LocationDetails(Icons.local_hospital_outlined, "Closest Bus Station(1Km)"),
  LocationDetails(Icons.local_hospital_outlined, "Closest School(1Km)"),
  LocationDetails(Icons.airplanemode_active_outlined, "Closest AirPort(5Km)"),
  LocationDetails(Icons.railway_alert_outlined, "Closest Train Station(1Km)"),
];

class LocationDetails {
  final IconData iconData;
  final String locationName;

  LocationDetails(this.iconData, this.locationName);
}
