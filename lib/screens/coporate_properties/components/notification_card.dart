import 'package:flutter/material.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {Key? key, required this.color, required this.iconData, required this.title, required this.subTitle})
      : super(key: key);
  final Color color;
  final IconData iconData;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      padding: EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.xl),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: Corners.lgBorder,
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, color: color),
          Spacer(),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.h3.copyWith(color: kBlackVariant)),
                SizedBox(height: 4),
                Text(
                  subTitle,
                  style: TextStyles.body14.copyWith(color: kBlackVariant.withOpacity(0.7)),
                )
              ],
            ),
          ),
          // Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.close, color: kSupportBlue, size: 20),
            ),
          )
          // IconButton(
          //   onPressed: () {},
          //   padding: EdgeInsets.all(0),
          //   iconSize: 20,
          //   icon: Icon(Icons.close, color: kSupportBlue),
          // )
        ],
      ),
    );
  }
}
