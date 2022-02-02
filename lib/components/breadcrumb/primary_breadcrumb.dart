import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';

class PrimaryBreadCrumb extends StatelessWidget {
  const PrimaryBreadCrumb({Key? key, this.keepPadding = false}) : super(key: key);
  final bool keepPadding;

  @override
  Widget build(BuildContext context) {
    EdgeInsets desktopContentPadding =
        EdgeInsets.symmetric(vertical: Insets.xxl / 2, horizontal: keepPadding ? Insets.offset : 0);

    return Container(
      padding: desktopContentPadding,
      alignment: Alignment.centerLeft,
      height: 90,
      child: Row(
        children: [
          Icon(Icons.keyboard_arrow_left_outlined),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              child: Text("Back to Home", style: TextStyles.body18.copyWith(color: kSupportBlue)),
            ),
          ),
          VerticalDivider(width: 1, color: Colors.black, endIndent: 16, indent: 16),
          BreadCrumb(
            items: [
              BreadCrumbItem(
                content: Text("Dubai",
                    style: TextStyles.body18.copyWith(color: kSupportBlue, decoration: TextDecoration.underline)),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
              BreadCrumbItem(
                content: Text("Green Community",
                    style: TextStyles.body18.copyWith(color: kSupportBlue, decoration: TextDecoration.underline)),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
              BreadCrumbItem(
                content: Text("Green Park",
                    style: TextStyles.body18.copyWith(color: kSupportBlue, decoration: TextDecoration.underline)),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
            ],
            divider: Icon(Icons.chevron_right, size: 15),
          ),
        ],
      ),
    );
  }
}
