import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/amenity_model.dart';
import '../../../models/property_details_models/property_location_detail_model.dart';

class PropertyDetailSecondaryDetailCard extends StatelessWidget {
  final int? bedroom;
  final int? bathroom;
  final int? sqft;
  final String? floor;
  final String? type;
  final List<AmenityModel> amenities;
  final List<AmenityModel> additionalFeatures;
  final String? desc;
  final LatLng? position;
  final PropertyLocationDetailModel locationDetails;

  const PropertyDetailSecondaryDetailCard({
    Key? key,
    this.bedroom,
    this.bathroom,
    this.sqft,
    this.floor,
    this.type,
    required this.amenities,
    required this.additionalFeatures,
    this.desc,
    this.position,
    required this.locationDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = Responsive.isMobile(context) ? SizedBox(height: Insets.med) : SizedBox(height: Insets.lg);
    Widget _lgVSpace = Responsive.isMobile(context) ? Container(height: Insets.med) : SizedBox(height: Insets.xxl);

    // Propery Details Section
    List<Widget> _details = [
      _propertyDetailRow(title: "$bedroom Bedrooms", icon: Icons.king_bed_outlined),
      _propertyDetailRow(title: "$bathroom Bathroom", icon: Icons.bathtub_outlined),
      _propertyDetailRow(title: "$sqft Sqft", icon: Icons.pie_chart_outlined),
      _propertyDetailRow(title: "$floor", icon: Icons.stairs_outlined),
      (type == null) ? Container() : _propertyDetailRow(title: "$type", icon: Icons.maps_home_work_outlined),
    ];

    Widget _propertyDetailTitle = Text(
      "Property Detail:",
      style: TextStyles.h2.copyWith(color: kBlackVariant),
    );

    List<Widget> _propertyDetail = [
      _propertyDetailTitle,
      _vSpace,
      Wrap(
        spacing: Insets.xxl,
        children: _details,
      ),
    ];

    // amenities
    List<Widget> _amenities = [
      Text("Amenities", style: TextStyles.h2.copyWith(color: kBlackVariant)),
      _vSpace,
      Wrap(
        // runSpacing: Insets.med,
        spacing: Insets.med,
        children: amenities.map((e) => _amenitiesRow(title: e.name.en, iconUrl: e.logo)).toList(),
      ),
    ];

    // additional features
    List<Widget> _additionalFeatures = [
      Text("Additional features", style: TextStyles.h2.copyWith(color: kBlackVariant)),
      _vSpace,
      Wrap(
          runSpacing: Insets.med,
          children: additionalFeatures.map((e) => _amenitiesRow(title: e.name.en, iconUrl: e.logo)).toList()),
    ];

    // Description
    List<Widget> _description = [
      Text(
        "Description:",
        style: TextStyles.h2.copyWith(color: kBlackVariant),
      ),
      _vSpace,
      SelectableText(
        desc?.replaceAll(RegExp(r'/[^\x20-\x7E]/g').pattern, ' ') ?? "Details not available",
        style: TextStyles.body16.copyWith(
          color: kBlackVariant.withOpacity(0.7),
        ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.lgBorder,
      ),
      padding: EdgeInsets.all(Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._propertyDetail,
          _lgVSpace,
          ..._amenities,
          _lgVSpace,
          if (additionalFeatures.isNotEmpty) ...[..._additionalFeatures, _lgVSpace],
          ..._description,
          _lgVSpace,
          ..._mapView,
        ],
      ),
    );
  }

  Widget _amenitiesRow({required String title, String? iconUrl}) {
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
            child: Image.network(iconUrl ?? ""),
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

  Widget _propertyDetailRow({
    required String title,
    required IconData icon,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: 160, height: 62),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: kSupportAccent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
              style: TextStyles.h3.copyWith(color: kSupportAccent),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
