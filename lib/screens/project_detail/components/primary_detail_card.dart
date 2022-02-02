import 'package:flutter/material.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/listing_cards/card_mixin.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class PrimaryDetailCard extends StatefulWidget {
  PrimaryDetailCard({Key? key, required this.name, required this.address}) : super(key: key);
  final String name;
  final String address;

  @override
  _PrimaryDetailCardState createState() => _PrimaryDetailCardState();
}

class _PrimaryDetailCardState extends State<PrimaryDetailCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    Widget _saveProperty = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Share On:", style: TextStyles.body18.copyWith(color: kSupportBlue)),
        SizedBox(width: 20),
        CustomIconButton(
          child: Icon(Icons.bookmark_outline_outlined, color: kSupportBlue),
          borderRadius: Corners.smBorder,
        ),
      ],
    );

    TextStyle _projectNameStyle = Responsive.isMobile(context) ? TextStyles.h3 : TextStyles.h2;
    Widget _projectName = Text(
      widget.name,
      style: _projectNameStyle.copyWith(color: kBlackVariant),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    TextStyle _locationTextStyle = Responsive.isMobile(context) ? TextStyles.h5 : TextStyles.h3;
    Widget _locationRow = locationRow(
        location: widget.address, textStyle: _locationTextStyle.copyWith(color: kSupportBlue), textMaxWidth: 422);

    Widget _verificationChip = Chip(
      label: Text(
        "Verified Project",
        style: TextStyles.body16.copyWith(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: kSupportGreen,
    );

    return Container(
      height: 160,
      padding: EdgeInsets.all(Insets.xl),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [_verificationChip],
              ),
              _projectName,
              _locationRow,
            ],
          ),
          if (Responsive.isDesktop(context)) ...[
            // Positioned(top: 0, right: 0, child: _saveProperty),
            Positioned(bottom: 0, right: 0, child: socialSharingRow),
          ]
        ],
      ),
    );
  }
}
