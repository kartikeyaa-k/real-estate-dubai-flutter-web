import 'package:flutter/material.dart';
import 'package:real_estate_portal/models/property_details_models/property_model.dart';

/// Hexadecimal opacity
/// 100% — FF
// 95% — F2
// 90% — E6
// 85% — D9
// 80% — CC
// 75% — BF
// 70% — B3
// 65% — A6
// 60% — 99
// 55% — 8C
// 50% — 80
// 45% — 73
// 40% — 66
// 35% — 59
// 30% — 4D
// 25% — 40
// 20% — 33
// 15% — 26
// 10% — 1A
// 5% — 0D
// 0% — 00
const MaterialColor kPrimaryColor = MaterialColor(
  _primaryValue,
  <int, Color>{
    0: const Color(_primaryValue),
    100: const Color(0xFF0079C2),
    80: const Color(0xCC0079C2),
    60: const Color(0x990079C2),
    40: const Color(0x660079C2),
    20: const Color(0x330079C2),
    10: const Color(0x1A0079C2),
    5: const Color(0x0D0079C2),
  },
);
const int _primaryValue = 0xFF002033;

const MaterialColor kAccentColor = MaterialColor(
  _accentValue,
  <int, Color>{
    0: const Color(_accentValue),
    100: const Color(0xFF820025),
    80: const Color(0xCC820025),
    60: const Color(0x99820025),
    40: const Color(0x66820025),
    20: const Color(0x33820025),
    10: const Color(0x1A820025),
    5: const Color(0x0D820025),
  },
);
const int _accentValue = 0xFF33000F;

const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

// Supporting colors
const kSupportRed = Color(0xFFC20000);
const kSupportBlue = Color(0xFF18A0FB);
const kLightBlue = Color(0xFF99C9E7);
const kSupportGreen = Color(0xFF00C21F);
const kSupportAccent = Color(0xFF9B3351);
const kBlackVariant = Color(0xFF002033);
const kDarkGrey = Color(0xFF4D6370);
const kBackgroundColor = Color(0xFFF3F3F3);
const kDisableColor = Color.fromRGBO(196, 196, 196, 0.5);
const kGrayCard = Color(0xFFF4F4F4);
const kErrorShade = Color.fromRGBO(253, 236, 236, 1);
const kPlainWhite = Colors.white;
const List<DropdownMenuItem<int>> itemList = [
  DropdownMenuItem(child: Text("One"), value: 1),
  DropdownMenuItem(child: Text("Two"), value: 2),
  DropdownMenuItem(child: Text("Three"), value: 3),
];

// Plan type
const List<DropdownMenuItem<PlanType>> lookingForMenuItems = const [
  DropdownMenuItem(child: Text("Rent"), value: PlanType.RENT),
  DropdownMenuItem(child: Text("Buy"), value: PlanType.BUY),
];

// Price list
const List<DropdownMenuItem<int>> minPriceItems = const [
  DropdownMenuItem(child: Text("0"), value: 0),
  DropdownMenuItem(child: Text("AED 10000"), value: 10000),
  DropdownMenuItem(child: Text("AED 20000"), value: 20000),
  DropdownMenuItem(child: Text("AED 60000"), value: 60000),
  DropdownMenuItem(child: Text("AED 200000"), value: 200000),
  DropdownMenuItem(child: Text("AED 400000"), value: 400000),
  DropdownMenuItem(child: Text("AED 4000000"), value: 4000000),
  DropdownMenuItem(child: Text("AED 8000000"), value: 8000000),
];

// Furnishing type
const List<DropdownMenuItem<FurnishedType>> furnishingListItems = const [
  DropdownMenuItem(child: Text("All"), value: FurnishedType.ANY),
  DropdownMenuItem(child: Text("Semi-furnished"), value: FurnishedType.SEMI_FURNISHED),
  DropdownMenuItem(child: Text("Furnished"), value: FurnishedType.FURNISHED),
  DropdownMenuItem(child: Text("Fully-furnished"), value: FurnishedType.FULLY_FURNISHED),
  DropdownMenuItem(child: Text("Unfurnished"), value: FurnishedType.UNFURNISHED),
];

// Area
const List<DropdownMenuItem<double>> areaItems = const [
  DropdownMenuItem(child: Text("100 sqft"), value: 100),
  DropdownMenuItem(child: Text("200 sqft"), value: 200),
  DropdownMenuItem(child: Text("300 sqft"), value: 300),
  DropdownMenuItem(child: Text("400 sqft"), value: 400),
  DropdownMenuItem(child: Text("500 sqft"), value: 500),
];

// Pay type
const List<DropdownMenuItem<PaymentType>> paymentTypeItems = const [
  DropdownMenuItem(child: Text("Monthly"), value: PaymentType.MONTHLY),
  DropdownMenuItem(child: Text("Half Yearly"), value: PaymentType.HALF_YEARLY),
  DropdownMenuItem(child: Text("Quarterly"), value: PaymentType.QUARTERLY),
  DropdownMenuItem(child: Text("Yearly"), value: PaymentType.YEARLY),
];

// min and max bedroom/bathroom
const List<DropdownMenuItem<int>> bathAndBedCountItems = const [
  DropdownMenuItem(child: Text("1"), value: 1),
  DropdownMenuItem(child: Text("2"), value: 2),
  DropdownMenuItem(child: Text("3"), value: 3),
  DropdownMenuItem(child: Text("4"), value: 4),
  DropdownMenuItem(child: Text("5"), value: 5),
  DropdownMenuItem(child: Text("6"), value: 6),
];
