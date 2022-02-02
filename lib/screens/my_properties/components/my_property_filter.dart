import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/input_fields/primary_dropdown_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

const BoxConstraints _kBoxConstraints = BoxConstraints(maxWidth: 320);

class MyPropertyFilter extends StatefulWidget {
  const MyPropertyFilter({
    Key? key,
    this.isFullPageView = false,
    this.isInProcessPage = false,
  }) : super(key: key);
  final bool isFullPageView;
  final bool isInProcessPage;

  @override
  _MyPropertyFilterState createState() => _MyPropertyFilterState();
}

enum PropertyStatus {
  InViewing,
  Negotiating,
  ContractApproval,
}

class _MyPropertyFilterState extends State<MyPropertyFilter> {
  late TextEditingController _searchController;
  final List<_Status> _propertyStatusCheckList = PropertyStatus.values.map((e) {
    String name = e.toString().substring(e.toString().indexOf(".") + 1);
    return _Status(
      text: name.replaceAllMapped(
        RegExp(r'([A-Z])'),
        (m) => ' ${m[1]}',
      ),
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.isFullPageView
          ? _kBoxConstraints.copyWith(maxWidth: double.infinity)
          : _kBoxConstraints,
      decoration: BoxDecoration(
        color: Colors.white,
        border: widget.isFullPageView
            ? null
            : Border.all(
                width: 1,
                color: Color.fromRGBO(0, 0, 0, 0.1),
              ),
        borderRadius: widget.isFullPageView ? null : Corners.xlBorder,
      ),
      padding: EdgeInsetsDirectional.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isFullPageView) ...[
            Row(
              children: [
                Text(
                  "Filter Properties",
                  style: TextStyles.h3,
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Clear Filters",
                    style: TextStyles.body12.copyWith(color: kSupportBlue),
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.xl),
          ],
          // Search bar
          Text(
            "Search",
            style: TextStyles.body14.copyWith(color: kLightBlue),
          ),
          SizedBox(height: 4),
          PrimaryTextField(
            controller: _searchController,
            text: "City, Tower Or Community",
          ),
          SizedBox(height: Insets.xl),
          // Divider
          Row(
            children: [
              Expanded(child: Divider(endIndent: 15)),
              Text("OR"),
              Expanded(child: Divider(indent: 15))
            ],
          ),
          SizedBox(height: Insets.xl),
          // Other Filters
          Text(
            "Property Type",
            style: TextStyles.body14.copyWith(color: kLightBlue),
          ),
          SizedBox(height: 4),
          PrimaryDropdownButton(
            // value: "dummy",
            itemList: [
              DropdownMenuItem(
                child: Text("data"),
              ),
            ],
          ),
          SizedBox(height: Insets.xl),
          Text(
            "Pay",
            style: TextStyles.body14.copyWith(color: kLightBlue),
          ),
          SizedBox(height: 4),
          PrimaryDropdownButton(
            // value: "dummy",
            itemList: [
              DropdownMenuItem(
                child: Text("data"),
              ),
            ],
          ),
          SizedBox(height: Insets.xl),

          Text(
            "Agency",
            style: TextStyles.body14.copyWith(color: kLightBlue),
          ),
          SizedBox(height: 4),
          PrimaryDropdownButton(
            // value: "dummy",
            itemList: [
              DropdownMenuItem(
                child: Text("data"),
              ),
            ],
          ),
          SizedBox(height: Insets.xl),
          if (widget.isInProcessPage) ...[
            Text(
              "Select Status",
              style: TextStyles.body14.copyWith(color: kLightBlue),
            ),
            ..._propertyStatusCheckList.map(
              (e) => CheckboxListTile(
                value: e.isChecked,
                onChanged: (isChecked) {
                  setState(() {
                    e.isChecked = isChecked;
                  });
                },
                title: Text(e.text, style: TextStyles.body16),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Status {
  String text;
  bool? isChecked;
  _Status({required this.text, this.isChecked = false});
}
