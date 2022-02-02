import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_portal/screens/project_listing/components/sorting_bar.dart';
import 'package:real_estate_portal/screens/project_listing/constants/project_list_contants.dart';
import 'package:vrouter/vrouter.dart';

import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';

class ProjectAppBarBottom extends StatefulWidget implements PreferredSizeWidget {
  const ProjectAppBarBottom({Key? key}) : super(key: key);

  @override
  _ProjectAppBarBottomState createState() => _ProjectAppBarBottomState();

  @override
  Size get preferredSize => Size.fromHeight(110);
}

class _ProjectAppBarBottomState extends State<ProjectAppBarBottom> {
  ProjectSortOptions? _sortOption;
  int? test = 0;

  SizedBox _button({required String text, required IconData iconData, required VoidCallback onTap}) {
    return SizedBox(
      height: 54,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 18),
              SizedBox(width: 10),
              Text(text, style: TextStyles.h4),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: _button(
              text: "Sort",
              iconData: Icons.sort,
              onTap: () {
                showModal(context);
              },
            ),
          ),
          VerticalDivider(width: 1, color: Color.fromRGBO(0, 0, 0, 0.05)),
          Expanded(
            child: _button(
              text: "Filter",
              iconData: Icons.filter_list,
              onTap: () {
                context.vRouter.to(ProjectFilterScreenPath, queryParameters: context.vRouter.queryParameters);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> showModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Corners.xlRadius),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Corners.xlRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort by",
                      style: TextStyles.body14.copyWith(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    ),
                    SizedBox(height: Insets.med),
                    ...ProjectSortOptions.projectSortingList.map(
                      (e) {
                        return RadioListTile<ProjectSortOptions>(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: e,
                          title: Text(e.name),
                          groupValue: _sortOption,
                          onChanged: (value) {
                            setState(() {
                              _sortOption = value;
                            });

                            // on tap update the url
                            Map<String, String> updateQuery = {...context.vRouter.queryParameters};

                            if (value == null) return;
                            if (updateQuery.containsKey(kProjSortingKey)) {
                              updateQuery.update(kProjSortingKey, (_) => value.value);
                            } else {
                              updateQuery[kProjSortingKey] = value.value;
                            }

                            context.vRouter.to(context.vRouter.path, queryParameters: updateQuery, isReplacement: true);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({required Widget child, required double minExtent, required double maxExtent})
      : _child = child,
        _maxExtent = maxExtent,
        _minExtent = minExtent;

  final Widget _child;
  final double _minExtent;
  final double _maxExtent;

  @override
  double get minExtent => _minExtent;
  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _child,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
