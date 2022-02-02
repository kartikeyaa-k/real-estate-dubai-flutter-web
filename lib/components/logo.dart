import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LogoType { dark, light }

class Logo extends StatelessWidget {
  const Logo({Key? key, this.size = 24, this.type = LogoType.dark}) : super(key: key);
  final double size;
  final LogoType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SvgPicture.asset(type == LogoType.light ? "assets/app/ADURE_LOGO-w.svg" : "assets/app/ADURE_LOGO.svg"),
      width: size,
      height: size,
    );
  }
}
