import 'package:flutter/material.dart';

import '../../../components/listing_cards/card_mixin.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class AgencyCoverDetails extends StatefulWidget {
  AgencyCoverDetails({Key? key}) : super(key: key);

  @override
  _AgencyCoverDetailsState createState() => _AgencyCoverDetailsState();
}

class _AgencyCoverDetailsState extends State<AgencyCoverDetails> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    Widget _verificationChip(TextStyle textStyle) => Chip(
          label: Text(
            "Verified Property",
            style: textStyle.copyWith(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: kSupportGreen,
        );

    Widget _agencyName = Text(
      "Dyson Projects Ltd.",
      style: TextStyles.h2.copyWith(color: kBlackVariant),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    Widget _brokerNumber = Text.rich(
      TextSpan(
        text: "Broker No:",
        style: TextStyles.h3.copyWith(color: kBlackVariant),
        children: [
          TextSpan(
            text: " 12121212",
            style: TextStyles.body18.copyWith(color: kBlackVariant.withOpacity(0.7)),
          )
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    Widget _locationRow = locationRow(textStyle: TextStyles.h3.copyWith(color: kSupportBlue), textMaxWidth: 422);

    Widget _agentCount = Row(
      children: [
        Icon(Icons.people_outline),
        SizedBox(width: 15),
        Text(
          "65 Agents",
          style: TextStyles.body18.copyWith(color: kBlackVariant.withOpacity(0.7)),
        )
      ],
    );

    Widget _webView = Container(
      height: 228,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_verificationChip(TextStyles.body16), _agencyName, _brokerNumber, _locationRow, _agentCount],
            ),
          ),
          Spacer(),
          socialSharingRow
        ],
      ),
    );

    Widget _tabletView = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 144),
      child: AspectRatio(
        aspectRatio: 139 / 24,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [_agencyName, Spacer(), _verificationChip(TextStyles.body12)],
              ),
              Spacer(),
              _locationRow,
              Spacer(),
              Row(
                children: [_agentCount, SizedBox(width: Insets.offset), _brokerNumber],
              )
            ],
          ),
        ),
      ),
    );

    Widget _mobileView = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 197, maxHeight: 230),
      child: AspectRatio(
        aspectRatio: 120 / 59,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_verificationChip(TextStyles.body12), _agencyName, _locationRow, _agentCount, _brokerNumber],
          ),
        ),
      ),
    );

    return Responsive(mobile: _mobileView, tablet: _tabletView, desktop: _webView);
  }
}
