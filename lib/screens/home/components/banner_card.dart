import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({Key? key, required this.text, required this.onTap, required this.child}) : super(key: key);
  final String text;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 217, minWidth: 156, maxHeight: 154, minHeight: 110),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: Responsive.isMobile(context) ? 0 : double.infinity,
          height: Responsive.isMobile(context) ? 0 : double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(blurRadius: 4, color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              SizedBox(height: 16),
              Text(
                text,
                style: TextStyles.body14.copyWith(fontWeight: FontWeight.w600, color: kBlackVariant),
              )
            ],
          ),
        ),
      ),
    );
  }
}
