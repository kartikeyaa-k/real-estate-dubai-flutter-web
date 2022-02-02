import 'package:flutter/material.dart';

import 'package:real_estate_portal/models/project_model/project_model.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class FloorPlan extends StatefulWidget {
  const FloorPlan({
    Key? key,
    required this.globalKey,
    this.floorPlans,
  }) : super(key: key);
  final GlobalKey globalKey;
  final List<FloorPlanModel>? floorPlans;

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> {
  bool _is3DPlan = false;

  @override
  Widget build(BuildContext context) {
    double _padding = Responsive.isMobile(context) ? Insets.lg : Insets.xl;

    Widget _primaryDropdownButton = PrimaryDropdownButton(/*value: "dummy",*/ itemList: [DropdownMenuItem(child: Text("data"))]);

    Widget _imageScrollView = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...widget.floorPlans!.map(
            (e) => Padding(
              padding: EdgeInsetsDirectional.only(end: Insets.lg),
              child: Image.asset(_is3DPlan ? e.threeDPlan : e.floorPlan),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(color: Colors.white, borderRadius: Responsive.isDesktop(context) ? Corners.lgBorder : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Floor Plans:", style: TextStyles.h2, key: widget.globalKey),
              Spacer(),
              Switch(
                value: _is3DPlan,
                onChanged: (value) {
                  setState(() => _is3DPlan = value);
                },
              ),
              Text("Show 3D", style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7))),
              if (!Responsive.isMobile(context)) ...[Spacer(flex: 2), Flexible(flex: 2, child: _primaryDropdownButton)]
            ],
          ),
          if (Responsive.isMobile(context)) ...[SizedBox(height: Insets.xl), _primaryDropdownButton],
          SizedBox(height: Insets.xl),
          widget.floorPlans == null ? Container() : _imageScrollView
        ],
      ),
    );
  }
}
