import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../constants/property_listing_const.dart';

class PropertySortOptions {
  final String name;
  final String value;

  const PropertySortOptions({required this.name, required this.value});

  static const List<PropertySortOptions> propertySortingList = [
    PropertySortOptions(name: "Newest", value: "newest"),
    PropertySortOptions(name: "Price High to Low", value: "pd"),
    PropertySortOptions(name: "Price Low to High", value: "pa"),
    PropertySortOptions(name: "Bedroom High to Low", value: "bd"),
    PropertySortOptions(name: "Bedroom Low to High", value: "ba"),
  ];
}

class PropertyListingTabBar extends StatefulWidget {
  PropertyListingTabBar({Key? key, required TabController tabController, this.showSorting = true})
      : _tabController = tabController,
        super(key: key);

  final TabController _tabController;
  final bool showSorting;

  @override
  _PropertyListingTabBarState createState() => _PropertyListingTabBarState();
}

class _PropertyListingTabBarState extends State<PropertyListingTabBar> {
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
          Padding(
            padding: EdgeInsetsDirectional.only(start: padding),
            child: TabBar(
              controller: widget._tabController,
              labelPadding: EdgeInsets.symmetric(horizontal: padding),
              isScrollable: true,
              indicatorColor: kSupportBlue,
              labelColor: Colors.black,
              unselectedLabelColor: kBlackVariant,
              labelStyle: TextStyles.h4.copyWith(color: kBlackVariant),
              indicatorWeight: 4,
              onTap: (index) {
                // on tap update the url
                Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                final String _typeKey = "type";
                String _type = "r";
                if (index == 0) {
                  _type = "r";
                } else {
                  _type = "c";
                }

                if (updateQuery.containsKey(_typeKey)) {
                  updateQuery.update(_typeKey, (value) => _type);
                } else {
                  updateQuery[_typeKey] = _type;
                }

                context.vRouter.to(context.vRouter.path, queryParameters: updateQuery, isReplacement: true);
              },
              tabs: [
                ...['Residential', 'Commercial'].map(
                  (e) => SizedBox(
                      child: Center(
                        child: Text(e),
                      ),
                      height: 80),
                )
              ],
            ),
          ),
          Spacer(),
          if (widget.showSorting)
            Padding(
              padding: EdgeInsetsDirectional.only(end: padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: comboBoxMaxWidth),
                child: PrimaryDropdownButton<String>(
                  hint: "Sort",
                  value: context.vRouter.queryParameters[kSortingKey],
                  onChanged: (value) {
                    // on tap update the url
                    Map<String, String> updateQuery = {...context.vRouter.queryParameters};

                    if (value == null || value.isEmpty) return;
                    if (updateQuery.containsKey(kSortingKey)) {
                      updateQuery.update(kSortingKey, (_) => value);
                    } else {
                      updateQuery[kSortingKey] = value;
                    }

                    context.vRouter.to(context.vRouter.path, queryParameters: updateQuery, isReplacement: true);
                  },
                  itemList: PropertySortOptions.propertySortingList
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e.value,
                          ))
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
