import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/property_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/listing_cards/card_mixin.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class Throttler {
  Throttler({this.throttleGapInMillis});

  final int? throttleGapInMillis;

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! > (throttleGapInMillis ?? 500)) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}

class PropertyDetailPrimaryDetailCard extends StatefulWidget {
  final String projectName;
  final String? location;
  final String? rating;
  final bool isVerified;

  PropertyDetailPrimaryDetailCard(
      {Key? key, required this.projectName, this.location, this.rating, this.isVerified = false})
      : super(key: key);

  @override
  _PropertyDetailPrimaryDetailCardState createState() => _PropertyDetailPrimaryDetailCardState();
}

class _PropertyDetailPrimaryDetailCardState extends State<PropertyDetailPrimaryDetailCard> with CommonCardMixin {
  var throttler = Throttler(throttleGapInMillis: 1000);

  @override
  Widget build(BuildContext context) {
    Widget _saveProperty = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!Responsive.isMobile(context)) ...[
          Text("Save Property:", style: TextStyles.body18.copyWith(color: kSupportBlue)),
          SizedBox(width: 20),
        ],
        BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
          builder: (context, state) {
            return CustomIconButton(
              backgroundColor: state.isBookmarked ? kSupportBlue : Colors.transparent,
              child: Icon(
                Icons.bookmark_outline_outlined,
                color: state.isBookmarked ? Colors.white : kSupportBlue,
              ),
              borderRadius: Corners.smBorder,
              onTap: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  context.vRouter.to(
                    LoginPath,
                    queryParameters: {"redirect": "${context.vRouter.url}"},
                  );
                }

                throttler.run(() {
                  context.read<PropertyDetailCubit>().bookmarkProperty();
                });
              },
            );
          },
        ),
      ],
    );

    TextStyle _projectNameStyle = Responsive.isMobile(context) ? TextStyles.h3 : TextStyles.h2;

    Widget _projectName = Text(
      widget.projectName,
      style: _projectNameStyle.copyWith(color: kBlackVariant),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    TextStyle _locationTextStyle = Responsive.isMobile(context) ? TextStyles.h5 : TextStyles.h3;

    Widget _locationRow = locationRow(
      location: widget.location,
      textStyle: _locationTextStyle.copyWith(color: kSupportBlue),
      textMaxWidth: 422,
    );

    Widget _verificationChip = Chip(
      backgroundColor: kSupportGreen,
      label: Text(
        "Verified Property",
        style: TextStyles.body16.copyWith(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    Widget _rating = Row(
      children: [
        Icon(
          Icons.star_rate_rounded,
          color: kAccentColor,
        ),
        SizedBox(width: Insets.sm),
        Text(
          widget.rating ?? "No ratings",
          style: TextStyles.body18.copyWith(color: kAccentColor, fontWeight: FontWeight.w500),
        ),
      ],
    );

    return Container(
      height: 195,
      padding: EdgeInsets.all(Insets.xl),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(children: [if (widget.isVerified) _verificationChip]),
              _projectName,
              _locationRow,
              _rating
            ],
          ),
          if (Responsive.isDesktop(context)) ...[
            Positioned(
              bottom: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _saveProperty,
                  SizedBox(height: Insets.xl),
                  socialSharingRow,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PropertyDetailPrimaryDetailCardSkeleton extends StatelessWidget {
  const PropertyDetailPrimaryDetailCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 170, height: 28, color: Colors.white),
          SizedBox(height: 20),
          Container(width: 445, height: 28, color: Colors.white),
          SizedBox(height: 16),
          Container(width: 445, height: 20, color: Colors.white),
        ],
      ),
    );
  }
}
