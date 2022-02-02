import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/styles.dart';
import '../constants/project_list_contants.dart';

class ProjectSortOptions {
  final String name;
  final String value;

  const ProjectSortOptions({required this.name, required this.value});

  static const List<ProjectSortOptions> projectSortingList = [
    ProjectSortOptions(name: "Price High to Low", value: "pd"),
    ProjectSortOptions(name: "Price Low to High", value: "pa"),
  ];
}

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
                child: PrimaryDropdownButton<String>(
                  hint: "Sort",
                  value: context.vRouter.queryParameters[kProjSortingKey],
                  onChanged: (value) {
                    // on tap update the url
                    Map<String, String> updateQuery = {...context.vRouter.queryParameters};

                    if (value == null || value.isEmpty) return;
                    if (updateQuery.containsKey(kProjSortingKey)) {
                      updateQuery.update(kProjSortingKey, (_) => value);
                    } else {
                      updateQuery[kProjSortingKey] = value;
                    }

                    context.vRouter.to(context.vRouter.path, queryParameters: updateQuery, isReplacement: true);
                  },
                  itemList: ProjectSortOptions.projectSortingList
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
