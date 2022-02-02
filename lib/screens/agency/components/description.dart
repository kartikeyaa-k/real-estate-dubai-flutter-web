import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textSize = Responsive.isMobile(context) ? TextStyles.body14 : TextStyles.body16;

    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? Insets.lg : Insets.xl),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: TextStyles.h2.copyWith(color: kBlackVariant)),
          SizedBox(height: Insets.lg),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam ornare id sagittis in. Sapien mattis nunc pretium fames. Diam feugiat id nunc ultrices sit. Et neque, fringilla porttitor faucibus in scelerisque purus, aliquet. Volutpat duis turpis et pretium libero. Felis etiam et proin vel amet elit at vitae pulvinar. Enim massa, urna ut arcu lorem. Ipsum imperdiet vitae neque lorem tincidunt in. Sem aliquam at nibh penatibus lobortis. Sapien, tellus, nunc, turpis ultricies elementum. Bibendum nisl, vitae pulvinar dui natoque vitae arcu quis.",
            style: textSize.copyWith(color: kBlackVariant.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
