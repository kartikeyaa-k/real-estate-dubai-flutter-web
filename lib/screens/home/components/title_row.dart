import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class TitleRow extends StatelessWidget {
  final String? title;

  /// Total count that is available
  final String? count;
  final VoidCallback? onViewAll;
  final ScrollController scrollController;

  /// list size
  final int listItemCount;

  const TitleRow({
    Key? key,
    this.title,
    this.count,
    this.onViewAll,
    required this.scrollController,
    required this.listItemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AutoSizeText(
            title!,
            style: TextStyles.h2.copyWith(color: kBlackVariant),
            presetFontSizes: [FontSizes.s20, FontSizes.s24],
            maxLines: 1,
          ),
        ),
        Spacer(),
        if (onViewAll != null)
          InkWell(
            child: AutoSizeText(
              "See All ($count)",
              style: TextStyles.body18.copyWith(color: kSupportBlue),
              maxFontSize: FontSizes.s18,
              presetFontSizes: [FontSizes.s12, FontSizes.s18],
              maxLines: 1,
            ),
            onTap: onViewAll,
          ),
        if (Responsive.isDesktop(context)) ...[
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              final itemWidth = scrollController.position.maxScrollExtent / listItemCount;
              final visibleWidth = MediaQuery.of(context).size.width - 200;
              final visibleCount = visibleWidth / itemWidth;
              double offset = scrollController.offset - visibleCount.floor() * itemWidth;

              scrollController.animateTo(offset, duration: Times.medium, curve: Curves.easeInOut);
            },
            icon: Icon(Icons.arrow_back_ios_sharp, size: 18),
          ),
          SizedBox(width: 30),
          IconButton(
            onPressed: () {
              final itemWidth = scrollController.position.maxScrollExtent / listItemCount;
              final visibleWidth = MediaQuery.of(context).size.width - 200;
              final visibleCount = visibleWidth / itemWidth;
              double offset = scrollController.offset + visibleCount.floor() * itemWidth;

              scrollController.animateTo(offset, duration: Times.medium, curve: Curves.easeInOut);
            },
            icon: Icon(Icons.arrow_forward_ios_sharp, size: 18),
          )
        ],
      ],
    );
  }
}
