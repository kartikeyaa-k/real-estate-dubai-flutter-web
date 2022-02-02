import 'dart:convert';

import 'package:easy_text_field/easy_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../injection_container.dart';
import '../../../models/home_page_model/property_types_model.dart';
import '../../../models/home_page_model/suggest_places_model.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../routes/routes.dart';
import '../../../services/home/home_services.dart';
import '../filter_bloc/home_filter_bloc.dart';

class HomeFilter extends StatefulWidget {
  HomeFilter({Key? key, required this.selectedTab}) : super(key: key);
  final String selectedTab;

  @override
  _HomeFilterState createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _seachController;
  late TextEditingController _keywordsController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _minAreaController;
  late TextEditingController _maxAreaController;
  int _selectedIndex = 0;
  int? selectedValue;

  List<PlacesResultModel> searchKeywordList = [];
  PlanType planType = PlanType.RENT;
  int? propertyTypeId;
  int? minPrice;
  int? maxPrice;
  FurnishedType furnishingType = FurnishedType.ANY;
  double? minArea;
  double? maxArea;
  List<String> keywords = [];
  bool isMinMaxPriceBanner = false;
  bool isMinMaxAreaBanner = false;
  double showLess = 160.0;
  double showMore = 380.0;
  bool isExpanded = false;

  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.selectedTab == "r" ? 0 : 1);
    _seachController = TextEditingController();
    _keywordsController = TextEditingController();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _minAreaController = TextEditingController();
    _maxAreaController = TextEditingController();

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _seachController.dispose();
    _keywordsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minAreaController.dispose();
    _maxAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Row forRentRow0 = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: EasyTextField<PlacesResultModel>(
            controller: _seachController,
            loadingBuilder: (context) => SpinKitChasingDots(color: kSupportBlue),
            itemBuilder: (context, data) {
              return ListTile(title: Text(data.name));
            },
            suggestionsCallback: (string) async {
              final searchEither = await sl<HomeServices>().getSuggestPlaces(string);
              SuggestPlacesModel suggestionList = SuggestPlacesModel.empty;
              searchEither.fold((l) => null, (suggestion) => suggestionList = suggestion);
              return suggestionList.result;
            },
            parseObjectToString: (data) {
              return data.toString();
            },
            onSuggestionSelected: (data) {
              searchKeywordList.add(data);
            },
            onDeleted: (data) {
              searchKeywordList.remove(data);
            },
          ),
          flex: 3,
        ),
        SizedBox(
          width: 20,
        ),
        PrimaryElevatedButton(
          text: 'Find Property',
          icon: Icon(Icons.search, color: Colors.white),
          onTap: () {
            context.vRouter.to(
              PropertyListingScreenPath,
              queryParameters: {
                "searchKeywordList": jsonEncode(searchKeywordList.map((e) => e.toJson()).toList()),
                "planType": PropertyModelEnumConverter.planTypeValues.reverse![planType]!,
                "propertyType": propertyTypeId.toString(),
                "minPrice": minPrice.toString(),
                "maxPrice": maxPrice.toString(),
                "paymentType": "",
                "furnishing": PropertyModelEnumConverter.furnishedStatusValues.reverse![furnishingType]!,
                "minArea": minArea.toString(),
                "maxArea": maxArea.toString(),
                "keywords": keywords.join(",")
              },
            );
          },
        )
      ],
    );

    Row forRentRow1 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 4,
          child: _FieldLayout(
            caption: "Looking for",
            child: PrimaryDropdownButton<PlanType>(
              itemList: lookingForMenuItems,
              value: PlanType.RENT,
              hint: "Rent or Buy",
              onChanged: (value) => planType = value ?? PlanType.RENT,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 4,
          child: _FieldLayout(
            caption: "Property Type",
            child: BlocBuilder<HomeFilterBloc, HomeFilterState>(
              builder: (context, state) {
                if (state.isLoadingPropertyTypes) {
                  return Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 2, color: kSupportBlue),
                      ),
                      child: SpinKitThreeBounce(color: kSupportBlue, size: 12));
                }
                return PrimaryDropdownButton<PropertyTypeModel>(
                  itemList: state.propertyTypeList.list
                      .map((e) => DropdownMenuItem<PropertyTypeModel>(child: Text(e.subTypeName.en), value: e))
                      .toList(),
                  hint: "Property Type",
                  onChanged: (value) => propertyTypeId = value?.id,
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: PortalEntry(
            visible: isMinMaxPriceBanner,
            portalAnchor: Alignment.topRight,
            childAnchor: Alignment.bottomRight,
            portal: Material(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  height: 120,
                  width: 400,
                  padding: EdgeInsets.all(Insets.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: PrimaryTextField(
                              controller: _minPriceController,
                              text: "Min Price (AED)",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                              ],
                              onChanged: (lowerValue) {
                                minPrice = int.tryParse(lowerValue.replaceAll(",", ""));
                                lowerValue = '${_formatNumber(lowerValue.replaceAll(',', ''))}';
                                _minPriceController.value = TextEditingValue(
                                  text: lowerValue,
                                  selection: TextSelection.collapsed(offset: lowerValue.length),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: PrimaryTextField(
                              controller: _maxPriceController,
                              text: "Max Price (AED)",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                              ],
                              onChanged: (upperValue) {
                                maxPrice = int.tryParse(upperValue.replaceAll(",", ""));
                                upperValue = '${_formatNumber(upperValue.replaceAll(',', ''))}';
                                _maxPriceController.value = TextEditingValue(
                                  text: upperValue,
                                  selection: TextSelection.collapsed(offset: upperValue.length),
                                );
                                setState(() {});
                              },
                            ),
                          )
                          // Expanded(
                          //   flex: 1,
                          //   child: FlutterSlider(
                          //     values: [minPrice.toDouble(), maxPrice.toDouble()],
                          //     max: 8000000,
                          //     min: 0,
                          //     step: FlutterSliderStep(step: 500000),
                          //     jump: true,
                          //     rangeSlider: true,
                          //     rtl: false,
                          //     trackBar: FlutterSliderTrackBar(
                          //       activeTrackBarHeight: 5,
                          //     ),
                          //     tooltip: FlutterSliderTooltip(
                          //       textStyle: TextStyle(fontSize: 17, color: Colors.lightBlue),
                          //     ),
                          //     handlerAnimation: FlutterSliderHandlerAnimation(
                          //         curve: Curves.elasticOut,
                          //         reverseCurve: null,
                          //         duration: Duration(milliseconds: 700),
                          //         scale: 1.4),
                          //     onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                          //       setState(() {
                          //         minPrice = lowerValue;
                          //         maxPrice = upperValue;
                          //       });
                          //     },
                          //     handler: FlutterSliderHandler(
                          //       child: Icon(
                          //         Icons.chevron_right,
                          //         color: Colors.red,
                          //         size: 24,
                          //       ),
                          //     ),
                          //     rightHandler: FlutterSliderHandler(
                          //       child: Icon(
                          //         Icons.chevron_left,
                          //         color: Colors.red,
                          //         size: 24,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                )),
            child: _FieldLayout(
              caption: "Min - Max Price",
              child: PrimaryTextField(
                text: ("${minPrice != null ? '${'${_formatNumber(minPrice.toString().replaceAll(',', ''))}'} AED' : 'Min'} - "
                    "${maxPrice != null ? '${'${_formatNumber(maxPrice.toString().replaceAll(',', ''))}'} AED' : 'Max Price'}"),
                onTap: () {
                  setState(() {
                    isMinMaxPriceBanner = !isMinMaxPriceBanner;
                  });
                },
              ),
            ),
          ),
        ),

        // Expanded(
        //   flex: 2,
        //   child: _FieldLayout(
        //     caption: "Min Price",
        //     child: PrimaryDropdownButton<int>(
        //       itemList: minPriceItems,
        //       hint: "No Min.",
        //       onChanged: (value) => minPrice = value,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: 20,
        // ),
        // Expanded(
        //   flex: 2,
        //   child: _FieldLayout(
        //     caption: "Max Price",
        //     child: PrimaryDropdownButton<int>(
        //       itemList: minPriceItems,
        //       hint: "No Max.",
        //       onChanged: (value) => maxPrice = value,
        //     ),
        //   ),
        // ),
      ],
    );

    Row forRentRow2 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 4,
          child: _FieldLayout(
            caption: "Furnishing",
            child: PrimaryDropdownButton<FurnishedType>(
              itemList: furnishingListItems,
              hint: "All Furnishing",
              onChanged: (value) => furnishingType = value ?? FurnishedType.ANY,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),

        Expanded(
          flex: 3,
          child: PortalEntry(
            visible: isMinMaxAreaBanner,
            portalAnchor: Alignment.topRight,
            childAnchor: Alignment.bottomRight,
            portal: Material(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  height: 120,
                  width: 400,
                  padding: EdgeInsets.all(Insets.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: PrimaryTextField(
                              controller: _minAreaController,
                              text: "Min Area(Sq Ft)",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                              ],
                              onChanged: (lowerValue) {
                                minArea = double.tryParse(lowerValue.replaceAll(",", ""));
                                lowerValue = '${_formatNumber(lowerValue.replaceAll(',', ''))}';
                                _minAreaController.value = TextEditingValue(
                                  text: lowerValue,
                                  selection: TextSelection.collapsed(offset: lowerValue.length),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: PrimaryTextField(
                              controller: _maxAreaController,
                              text: "Max Area(Sq Ft)",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                              ],
                              onChanged: (upperValue) {
                                maxArea = double.tryParse(upperValue.replaceAll(",", ""));
                                upperValue = '${_formatNumber(upperValue.replaceAll(',', ''))}';
                                _maxAreaController.value = TextEditingValue(
                                  text: upperValue,
                                  selection: TextSelection.collapsed(offset: upperValue.length),
                                );
                                setState(() {});
                              },
                            ),
                          )
                          // Expanded(
                          //   flex: 1,
                          //   child: FlutterSlider(
                          //     values: [minArea.toDouble(), maxArea.toDouble()],
                          //     max: 6000,
                          //     min: 0,
                          //     step: FlutterSliderStep(step: 500),
                          //     jump: true,
                          //     rangeSlider: true,
                          //     rtl: false,
                          //     trackBar: FlutterSliderTrackBar(
                          //       activeTrackBarHeight: 5,
                          //     ),
                          //     tooltip: FlutterSliderTooltip(
                          //       textStyle: TextStyle(fontSize: 17, color: Colors.lightBlue),
                          //     ),
                          //     handlerAnimation: FlutterSliderHandlerAnimation(
                          //         curve: Curves.elasticOut,
                          //         reverseCurve: null,
                          //         duration: Duration(milliseconds: 700),
                          //         scale: 1.4),
                          //     onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                          //       setState(() {
                          //         minArea = lowerValue;
                          //         maxArea = upperValue;
                          //       });
                          //     },
                          //     handler: FlutterSliderHandler(
                          //       child: Icon(
                          //         Icons.chevron_right,
                          //         color: Colors.red,
                          //         size: 24,
                          //       ),
                          //     ),
                          //     rightHandler: FlutterSliderHandler(
                          //       child: Icon(
                          //         Icons.chevron_left,
                          //         color: Colors.red,
                          //         size: 24,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                )),
            child: _FieldLayout(
              caption: "Min - Max Area",
              child: PrimaryTextField(
                text: "${minArea != null ? '${'${_formatNumber(minArea.toString().replaceAll(',', ''))}'} Sq Ft' : 'Min'} - " +
                    "${maxArea != null ? '${'${_formatNumber(maxArea.toString().replaceAll(',', ''))}'} Sq Ft' : 'Max Area'}",
                onTap: () {
                  setState(() {
                    isMinMaxAreaBanner = !isMinMaxAreaBanner;
                  });
                },
              ),
            ),
          ),
        ),

        // Expanded(
        //   flex: 2,
        //   child: _FieldLayout(
        //     caption: "Min Area",
        //     child: PrimaryDropdownButton<double>(itemList: areaItems, hint: "No Min.", onChanged: (value) => minArea = value),
        //   ),
        // ),
        // SizedBox(
        //   width: 20,
        // ),
        // Expanded(
        //   flex: 2,
        //   child: _FieldLayout(
        //     caption: "Max Area",
        //     child: PrimaryDropdownButton<double>(itemList: areaItems, hint: "No Max.", onChanged: (value) => maxArea = value),
        //   ),
        // ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 4,
          child: _FieldLayout(
            caption: "Keywords",
            child: TextFieldTags(
              tagsStyler: TagsStyler(
                tagMargin: const EdgeInsets.only(right: 4.0),
                tagCancelIcon: Icon(Icons.cancel, size: 15.0, color: Colors.black),
                tagCancelIconPadding: EdgeInsets.only(left: 4.0, top: 2.0),
                tagPadding: EdgeInsets.only(top: 2.0, bottom: 4.0, left: 8.0, right: 4.0),
                tagDecoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                tagTextStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              textFieldStyler: TextFieldStyler(
                hintText: "Near Beach, River...",
                textStyle: TextStyles.body16,
                textFieldBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                textFieldFocusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2.5, color: kSupportBlue),
                ),
                textFieldEnabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: kLightBlue),
                ),
              ),
              onTag: (tag) => keywords.add(tag),
              onDelete: (tag) => keywords.remove(tag),
            ),
          ),
        ),
      ],
    );

    return Positioned(
      bottom: isExpanded ? 10 : 110,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 992, height: isExpanded ? 380 : 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 330, minWidth: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: _selectedIndex == 0 ? Radius.circular(12) : Radius.zero,
                      topRight: _selectedIndex == 0 ? Radius.zero : Radius.circular(12),
                    ),
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyles.h3,
                  isScrollable: Responsive.isDesktop(context) ? false : true,
                  tabs: [
                    Text('Residential'),
                    Text('Commercial Rent'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Corners.xlRadius, bottomLeft: Corners.xlRadius, bottomRight: Corners.xlRadius),
                  boxShadow: Shadows.universal,
                ),
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // First Tab
                    Container(
                      key: ValueKey("for-rent"),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          forRentRow0,
                          SizedBox(height: 20),
                          isExpanded ? forRentRow1 : Container(),
                          isExpanded ? SizedBox(height: 20) : Container(),
                          isExpanded ? forRentRow2 : Container(),
                          isExpanded ? SizedBox(height: 20) : Container(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isExpanded ? 'Show Less' : 'Show More',
                                  style: TS.miniestHeaderBlack,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(isExpanded ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Second Tab
                    Container(
                      key: ValueKey("for-commercial"),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          forRentRow0,
                          SizedBox(height: 20),
                          isExpanded ? forRentRow1 : Container(),
                          isExpanded ? SizedBox(height: 20) : Container(),
                          isExpanded ? forRentRow2 : Container(),
                          isExpanded ? SizedBox(height: 20) : Container(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isExpanded ? 'Show Less' : 'Show More',
                                  style: TS.miniestHeaderBlack,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(isExpanded ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLayout extends StatelessWidget {
  const _FieldLayout({
    Key? key,
    required String caption,
    required Widget child,
  })  : _caption = caption,
        _child = child,
        super(key: key);

  final String _caption;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_caption, style: TextStyles.body12.copyWith(color: Color(0xFF99C9E7))),
        SizedBox(height: 4),
        _child
      ],
    );
  }
}
