import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';

class CustomIconButton extends StatefulWidget {
  /// Create a icon button with on hover effects, while creating an instance either
  /// one of [icon] or [child] should have value.
  CustomIconButton({
    Key? key,
    this.onHoverBorderColor,
    this.backgroundColor = Colors.transparent,
    // this.width = 50,
    this.size = 50,
    this.iconColor = kSupportBlue,
    this.selectedChild,
    this.isSelected = false,
    this.showBorder = true,
    required this.child,
    this.borderRadius,
    this.onTap,
  }) :
        // assert(widget.icon == null && widget.child == null, 'child and icon both cannot be null');
        // assert(widget.icon != null && widget.child != null, 'both child and icon cannot have null value'),
        super(key: key);

  final Color? onHoverBorderColor;
  final Color backgroundColor;
  // final double width;
  // final double height;
  final double size;
  final Color iconColor;
  final Widget? selectedChild;
  final bool isSelected;
  final bool showBorder;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  List<BoxShadow>? shadow;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          if (hovering) {
            setState(() {
              shadow = Shadows.small;
            });
          } else {
            setState(() {
              shadow = [];
            });
          }
        },
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: Times.fast,
          width: Responsive.isMobile(context) ? 45 : widget.size,
          height: Responsive.isMobile(context) ? 45 : widget.size,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: shadow,
              border: Border.all(width: 1, color: widget.showBorder ? widget.iconColor : Colors.transparent),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8)),
          child: widget.isSelected
              ? SizedBox(width: 24, height: 24, child: widget.child)
              : SizedBox(width: 24, height: 24, child: widget.child),
        ),
      ),
    );
  }
}
