import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import 'card_mixin.dart';

class FlexibleCard extends StatefulWidget {
  FlexibleCard({Key? key, this.lineThreeWidget, this.lineFourWidget, this.lineFiveWidget}) : super(key: key);
  // final double aspectRatio;
  final Widget? lineThreeWidget;
  final Widget? lineFourWidget;
  final Widget? lineFiveWidget;

  @override
  _FlexibleCardState createState() => _FlexibleCardState();
}

class _FlexibleCardState extends State<FlexibleCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: kBlackVariant.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            cardImage(),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title text
                    Text("The Biggest 4 Bed Layout (2C) | VOT", style: TextStyles.h3),

                    // Location row
                    Spacer(flex: 1),
                    locationRow(),

                    // Line three widget
                    if (widget.lineThreeWidget != null) ...[
                      Spacer(flex: 2),
                      widget.lineThreeWidget!,
                    ],

                    // Line four widget
                    if (widget.lineFourWidget != null) ...[
                      Spacer(flex: 2),
                      widget.lineFourWidget!,
                    ],

                    // Line five widget
                    if (widget.lineFiveWidget != null) ...[
                      Spacer(flex: 2),
                      widget.lineFiveWidget!,
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
