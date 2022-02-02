import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/constants.dart';

/// //////////////////////////////////////////////////////////////
/// Styles - Contains the design system for the entire app.
/// Includes paddings, text styles, timings etc. Does not include colors, check [AppTheme] file for that.

/// Used for all animations in the  app
class Times {
  static const Duration fastest = const Duration(milliseconds: 150);
  static const fast = const Duration(milliseconds: 250);
  static const medium = const Duration(milliseconds: 350);
  static const slow = const Duration(milliseconds: 700);
  static const slower = const Duration(milliseconds: 1000);
}

class Sizes {
  static double hitScale = 1;
  static double get hit => 40 * hitScale;
}

class IconSizes {
  static const double scale = 1;
  static const double med = 24;
}

class Insets {
  static double scale = 1;
  static double offsetScale = 1;
  // Regular paddings
  static double get xs => 4 * scale;
  static double get sm => 8 * scale;
  static double get med => 12 * scale;
  static double get lg => 16 * scale;
  static double get xl => 20 * scale;
  static double get xxl => 32 * scale;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 100 * offsetScale;
  static double get oldOffset => 40 * offsetScale;
  static double get toolBarSize => 100;
  static double get footerSize => 353;
  // maxWidth used for screens that need constrainted width
  static double get maxWidth => 1666;
}

class Corners {
  static const double sm = 4;
  static const BorderRadius smBorder = const BorderRadius.all(smRadius);
  static const Radius smRadius = const Radius.circular(sm);

  static const double med = 5;
  static const BorderRadius medBorder = const BorderRadius.all(medRadius);
  static const Radius medRadius = const Radius.circular(med);

  static const double lg = 8;
  static const BorderRadius lgBorder = const BorderRadius.all(lgRadius);
  static const Radius lgRadius = const Radius.circular(lg);

  static const double xl = 12;
  static const BorderRadius xlBorder = const BorderRadius.all(xlRadius);
  static const Radius xlRadius = const Radius.circular(xl);
}

class Strokes {
  static const double thin = 1;
  static const double thick = 4;
}

class Shadows {
  static List<BoxShadow> get universal => [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 10),
            blurRadius: 10),
      ];
  static List<BoxShadow> get small => [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4)),
        BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0)),
      ];
  static List<BoxShadow> get smallReverse => [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, -4)),
        BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0)),
      ];

  static List<BoxShadow> get dense => [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 4)),
        BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0)),
      ];
}

/// Font Sizes
/// You can use these directly if you need, but usually there should be a predefined style in TextStyles.
class FontSizes {
  /// Provides the ability to nudge the app-wide font scale in either direction
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s18 => 18 * scale;
  static double get s20 => 20 * scale;
  static double get s24 => 24 * scale;
  static double get s36 => 36 * scale;
  static double get s48 => 48 * scale;
}

/// Fonts - A list of Font Families, this is uses by the TextStyles class to create concrete styles.
class Fonts {
  static const String roboto = "Roboto";
}

/// TextStyles - All the core text styles for the app should be declared here.
/// Don't try and create every variant in existence here, just the high level ones.
/// More specific variants can be created on the fly using `style.copyWith()`
/// `newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: Colors.red)`
class TextStyles {
  /// Declare a base style for each Family
  static const TextStyle roboto = const TextStyle(
      fontFamily: Fonts.roboto, fontWeight: FontWeight.w400, height: 1);

  static TextStyle get h1 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s36,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get h2 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s24,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle get extraBoldh1 => roboto.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s36,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle get h3 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s18,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get h4 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s16,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get h5 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s14,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get h6 => roboto.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body10 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s10,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body12 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body14 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s14,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body16 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s16,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body18 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s18,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body24 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s24,
      height: 1.17,
      color: kBlackVariant);
  static TextStyle get body30 => roboto.copyWith(
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kSupportBlue);

  static TextStyle get smallestBlueText => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kSupportBlue);

  static TextStyle get smallestBlackText => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle get smallestWhiteText => roboto.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s12,
      height: 1.17,
      color: kBackgroundColor);
}

// For all static pages following these
class TS {
  static TextStyle largestWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s48,
      color: Colors.white);

  static TextStyle headerWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s36,
      color: Colors.white);

  static TextStyle miniHeaderBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s24,
      color: kBlackVariant);

  static TextStyle miniHeaderGray = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s24,
      color: Colors.black87);

  static TextStyle miniHeaderWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s24,
      color: Colors.white);

  static TextStyle miniestHeaderWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s16,
      color: Colors.white);
  static TextStyle miniestHeaderBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s16,
      color: kBlackVariant);

  static TextStyle bodyGray = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s14,
      color: Colors.black54);

  static TextStyle bodyWhite = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s14,
      color: Colors.white);

  static TextStyle bodyBlack = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s14,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle lableBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s24,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle lableWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s24,
      height: 1.17,
      color: kPlainWhite);
}

class MS {
  static TextStyle largestWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s48,
      color: Colors.white);

  static TextStyle headerWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s36,
      color: Colors.white);

  static TextStyle miniHeaderBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s14,
      color: kBlackVariant);

  static TextStyle miniHeaderGray = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w700,
      fontSize: FontSizes.s24,
      color: Colors.black87);

  static TextStyle miniHeaderWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s24,
      color: Colors.white);

  static TextStyle miniestHeaderWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s12,
      color: Colors.white);
  static TextStyle miniestHeaderBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s16,
      color: kBlackVariant);

  static TextStyle bodyGray = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s10,
      color: Colors.black54);

  static TextStyle bodyWhite = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s10,
      color: Colors.white);

  static TextStyle bodyBlack = TextStyle(
      fontFamily: Fonts.roboto,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w400,
      fontSize: FontSizes.s10,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle lableBlack = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s18,
      height: 1.17,
      color: kBlackVariant);

  static TextStyle lableWhite = TextStyle(
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w500,
      fontSize: FontSizes.s18,
      height: 1.17,
      color: kPlainWhite);
}
