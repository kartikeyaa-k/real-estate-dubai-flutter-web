import 'package:flutter/material.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/styles.dart';

class SortingBar extends StatefulWidget {
  SortingBar({Key? key, this.showSorting = true}) : super(key: key);

  final bool showSorting;

  @override
  _SortingBarState createState() => _SortingBarState();
}

class _SortingBarState extends State<SortingBar> {
  @override
  Widget build(BuildContext context) {
    final bool adjustmentCondition = MediaQuery.of(context).size.width > 665;
    final double padding = adjustmentCondition ? Insets.xl : Insets.lg;
    final double comboBoxMaxWidth = adjustmentCondition ? 200 : 180;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: Shadows.universal,
          borderRadius: widget.showSorting ? Corners.lgBorder : null),
      constraints: BoxConstraints(maxWidth: Insets.maxWidth),
      height: 80,
      child: Row(
        children: [
          Spacer(),
          if (widget.showSorting)
            Padding(
              padding: EdgeInsetsDirectional.only(end: padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: comboBoxMaxWidth),
                child: PrimaryDropdownButton(itemList: [DropdownMenuItem(child: Text("data"))]),
              ),
            )
        ],
      ),
    );
  }
}
