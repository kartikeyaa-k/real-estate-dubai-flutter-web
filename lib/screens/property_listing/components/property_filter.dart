import 'dart:convert';

import 'package:easy_text_field/easy_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../../injection_container.dart';
import '../../../models/home_page_model/property_types_model.dart';
import '../../../models/home_page_model/suggest_places_model.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../services/home/home_services.dart';
import '../constants/property_listing_const.dart';
import '../cubit/property_listing_cubit.dart';

enum FilterType { Search, Keywords, Price, PropertySpecification, BedroomsBathrooms, Amenities, Others }

const BoxConstraints _kBoxConstraints = BoxConstraints(maxWidth: 320);

_goto({required BuildContext context, required String path, required Map<String, String> queryParameters}) {
  if (queryParameters.containsKey(kPageNumberKey)) {
    queryParameters.update(kPageNumberKey, (value) => "1");
  } else {
    queryParameters[kPageNumberKey] = "1";
  }
  context.vRouter.to(path, isReplacement: true, queryParameters: queryParameters);
}

class PropertyFilter extends StatefulWidget {
  PropertyFilter({Key? key, this.isFullPageView = false, required this.cubit}) : super(key: key);
  final bool isFullPageView;
  final PropertyListingCubit cubit;

  @override
  _PropertyFilterState createState() => _PropertyFilterState();
}

class _PropertyFilterState extends State<PropertyFilter> {
  List<_FilterItem> _filterItems =
      FilterType.values.map((e) => _FilterItem(filterType: e, isExpanded: e == FilterType.Search)).toList();

  @override
  void initState() {
    super.initState();
    widget.cubit.loadFilterData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.isFullPageView ? _kBoxConstraints.copyWith(maxWidth: double.infinity) : _kBoxConstraints,
      decoration: BoxDecoration(
        color: Colors.white,
        border: widget.isFullPageView ? null : Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
        borderRadius: widget.isFullPageView ? null : Corners.xlBorder,
      ),
      padding: EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          if (!widget.isFullPageView)
            Row(
              children: [
                Text("Filter Properties", style: TextStyles.h3),
                Spacer(),
                InkWell(
                  onTap: () {
                    context.vRouter.to(context.vRouter.path, isReplacement: true);
                  },
                  child: Text("Clear Filters", style: TextStyles.body12.copyWith(color: kSupportBlue)),
                )
              ],
            ),
          _buildPanel()
        ],
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _filterItems[index].isExpanded = !isExpanded;
        });
      },
      children: _filterItems.map((_FilterItem item) {
        return ExpansionPanel(
          isExpanded: item.isExpanded,
          headerBuilder: (_, isExpanded) {
            return Align(alignment: Alignment.centerLeft, child: Text(item.title));
          },
          body: item.body,
        );
      }).toList(),
    );
  }
}

class _FilterItem {
  FilterType filterType;
  String _title = "";
  Widget? _widget;
  bool isExpanded;

  _FilterItem({required this.filterType, this.isExpanded = false}) {
    switch (filterType) {
      case FilterType.Search:
        this._title = "Search";
        this._widget = _SearchSection();
        break;
      case FilterType.Keywords:
        this._title = "Keywords";
        this._widget = _KeywordSection();
        break;
      case FilterType.Price:
        this._title = "Price";
        this._widget = _PriceSection();
        break;
      case FilterType.PropertySpecification:
        this._title = "Property Specification";
        this._widget = PropertySpecificationSection();
        break;
      case FilterType.BedroomsBathrooms:
        this._title = "Bedrooms & Bathrooms";
        this._widget = BedroomBathroomSection();
        break;
      case FilterType.Amenities:
        this._title = "Amenities";
        this._widget = _AmenitiesSection();
        break;
      case FilterType.Others:
        this._title = "Others";
        this._widget = _OthersSection();
        break;
      default:
        this._title = "Price";
        this._widget = _PriceSection();
    }
  }

  get title => _title;
  get body => _widget;
}

class _Layout extends StatelessWidget {
  const _Layout({
    Key? key,
    required String label,
    required Widget child,
  })  : _label = label,
        _child = child,
        super(key: key);

  final String _label;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(_label, style: TextStyles.body14.copyWith(color: kLightBlue)), SizedBox(height: 4), _child],
    );
  }
}

//* Search
class _SearchSection extends StatefulWidget {
  _SearchSection({Key? key}) : super(key: key);

  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  late TextEditingController _seachController;
  List<PlacesResultModel> searchKeywordList = [];
  String _key = "searchKeywordList";

  @override
  void initState() {
    super.initState();
    _seachController = TextEditingController();
  }

  @override
  void dispose() {
    _seachController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List searchKeywords = jsonDecode(context.vRouter.queryParameters[_key] ?? "[]");
    searchKeywordList = searchKeywords.map((json) => PlacesResultModel.fromJson(jsonDecode(jsonEncode(json)))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return EasyTextField<PlacesResultModel>(
      controller: _seachController,
      initialValue: searchKeywordList,
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

        // copy the existing parameters and update with new value
        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
        if (updateQuery.containsKey(_key)) {
          updateQuery.update(_key, (value) => jsonEncode(searchKeywordList.map((e) => e.toJson()).toList()));
        } else {
          updateQuery[_key] = jsonEncode(searchKeywordList.map((e) => e.toJson()).toList());
        }
        // replace the route
        _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
      },
      onDeleted: (data) {
        searchKeywordList.remove(data);

        // copy the existing parameters and update with new value
        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
        if (updateQuery.containsKey(_key)) {
          updateQuery.update(_key, (value) => jsonEncode(searchKeywordList.map((e) => e.toJson()).toList()));
        } else {
          updateQuery[_key] = jsonEncode(searchKeywordList.map((e) => e.toJson()).toList());
        }
        // replace the route
        _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
      },
    );
  }
}

//* Keywords
class _KeywordSection extends StatefulWidget {
  const _KeywordSection({Key? key}) : super(key: key);

  @override
  _KeywordSectionState createState() => _KeywordSectionState();
}

class _KeywordSectionState extends State<_KeywordSection> {
  String _keywordsKey = "keywords";
  List<String>? initialTags;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialTags = context.vRouter.queryParameters[_keywordsKey]?.trim().split(",") ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      initialTags: initialTags,
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
      onTag: (tag) {
        if (tag.isEmpty) return;

        // copy the existing parameters and update with new value
        Map<String, String> updateQuery = {...context.vRouter.queryParameters};

        if (updateQuery.containsKey(_keywordsKey)) {
          final tags = [...updateQuery[_keywordsKey]?.split(",") ?? [], tag];
          updateQuery.update(_keywordsKey, (value) => tags.join(","));
        } else {
          updateQuery[_keywordsKey] = [tag].join(",");
        }
        // replace the route
        _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
      },
      onDelete: (tag) {
        if (tag.isEmpty) return;
        List<String> currentKeywords = context.vRouter.queryParameters[_keywordsKey] != null
            ? context.vRouter.queryParameters[_keywordsKey]!.split(",")
            : [];
        currentKeywords.removeWhere((element) => element == tag);
        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
        // update route
        if (updateQuery.containsKey(_keywordsKey))
          updateQuery.update(_keywordsKey, (value) => currentKeywords.join(","));

        // replace the route
        _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
      },
    );
  }
}

//* Price section
class _PriceSection extends StatefulWidget {
  const _PriceSection({Key? key}) : super(key: key);

  @override
  State<_PriceSection> createState() => _PriceSectionState();
}

class _PriceSectionState extends State<_PriceSection> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  final String _minPriceKey = kMinPriceKey;
  final String _maxPriceKey = kMaxPriceKey;
  final String _payTypeKey = kPaymentType;

  String? _minPrice;
  String? _maxPrice;
  PaymentType? _payType;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minPrice = context.vRouter.queryParameters[_minPriceKey];
    _minPriceController.value = TextEditingValue(
      text: _minPrice ?? "",
      selection: TextSelection.collapsed(offset: _minPrice?.length ?? 0),
    );
    _maxPrice = context.vRouter.queryParameters[_maxPriceKey];
    _maxPriceController.value = TextEditingValue(
      text: _maxPrice ?? "",
      selection: TextSelection.collapsed(offset: _maxPrice?.length ?? 0),
    );

    _payType = context.vRouter.queryParameters[_payTypeKey] != null
        ? PropertyModelEnumConverter.paymentTypeValues.map[context.vRouter.queryParameters[_payTypeKey]]
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Map<String, String> updateQuery = {...context.vRouter.queryParameters};
              updateQuery.remove(_minPriceKey);
              updateQuery.remove(_maxPriceKey);
              setState(() {
                _minPrice = null;
                _maxPrice = null;
              });
              updateQuery.remove(_payTypeKey);
              _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
            },
            child: Text(
              "clear",
              style: TextStyles.body14.copyWith(color: kDarkGrey, decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Min Price",
                  child: PrimaryTextField(
                    // initialValue: _minPrice,
                    text: "Min Price(AED)",
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (upperValue) {
                      int? minPrice = int.tryParse(upperValue.replaceAll(",", ""));
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_minPriceKey)) {
                        updateQuery.update(_minPriceKey, (_) => (minPrice ?? "").toString());
                      } else {
                        updateQuery[_minPriceKey] = minPrice.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              ),
              // Spacer(),
              SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Max Price",
                  child: PrimaryTextField(
                    controller: _maxPriceController,
                    text: "Max Price(AED)",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (upperValue) {
                      int? maxPrice = int.tryParse(upperValue.replaceAll(",", ""));
                      // copy the existing parameters and update with new value
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_maxPriceKey)) {
                        updateQuery.update(_maxPriceKey, (_) => (maxPrice ?? "").toString());
                      } else {
                        updateQuery[_maxPriceKey] = maxPrice.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          _Layout(
            label: "Pay",
            child: PrimaryDropdownButton<PaymentType>(
              itemList: paymentTypeItems,
              value: _payType,
              onChanged: (value) {
                // copy the existing parameters and update with new value
                Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                if (updateQuery.containsKey(_payTypeKey)) {
                  updateQuery.update(_payTypeKey, (_) => PropertyModelEnumConverter.paymentTypeValues.reverse![value]!);
                } else {
                  updateQuery[_payTypeKey] = PropertyModelEnumConverter.paymentTypeValues.reverse![value]!;
                }
                // replace the route
                _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
              },
            ),
          ),
        ],
      ),
    );
  }
}

//* Property Specification section

class PropertySpecificationSection extends StatefulWidget {
  const PropertySpecificationSection({Key? key}) : super(key: key);

  @override
  _PropertySpecificationSectionState createState() => _PropertySpecificationSectionState();
}

class _PropertySpecificationSectionState extends State<PropertySpecificationSection> {
  late TextEditingController _minAreaController;
  late TextEditingController _maxAreaController;

  final String _propertyTypeKey = "propertyType";
  final String _minAreaKey = "minArea";
  final String _maxAreaKey = "maxArea";

  String? _minArea;
  String? _maxArea;
  int? _propertyType;

  @override
  void initState() {
    super.initState();
    _minAreaController = TextEditingController();
    _maxAreaController = TextEditingController();
  }

  @override
  void dispose() {
    _minAreaController.dispose();
    _maxAreaController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _propertyType = int.tryParse(context.vRouter.queryParameters[_propertyTypeKey] ?? "");

    _minArea = context.vRouter.queryParameters[_minAreaKey];
    _minAreaController.value = TextEditingValue(
      text: _minArea ?? "",
      selection: TextSelection.collapsed(offset: _minArea?.length ?? 0),
    );
    _maxArea = context.vRouter.queryParameters[_maxAreaKey];
    _maxAreaController.value = TextEditingValue(
      text: _maxArea ?? "",
      selection: TextSelection.collapsed(offset: _maxArea?.length ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Layout(
            label: "Property Type",
            child: BlocBuilder<PropertyListingCubit, PropertyListingState>(
              builder: (context, state) {
                var selectedValue = state.propertyTypeList.list
                    .firstWhere((e) => e.id == _propertyType, orElse: () => PropertyTypeModel.empty);

                if (state.status.isSubmissionInProgress)
                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(width: 2, color: kSupportBlue),
                    ),
                    child: SpinKitThreeBounce(color: kSupportBlue, size: 12),
                  );

                return PrimaryDropdownButton<PropertyTypeModel>(
                  value: selectedValue == PropertyTypeModel.empty ? null : selectedValue,
                  itemList: state.propertyTypeList.list
                      .map((e) => DropdownMenuItem<PropertyTypeModel>(child: Text(e.subTypeName.en), value: e))
                      .toList(),
                  onChanged: (value) {
                    // copy the existing parameters and update with new value
                    Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                    String val = value?.id.toString() ?? "";
                    if (updateQuery.containsKey(_propertyTypeKey)) {
                      updateQuery.update(_propertyTypeKey, (_) => val);
                    } else {
                      updateQuery[_propertyTypeKey] = val;
                    }
                    // replace the route
                    _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Min Area(Sq Ft)",
                  child: PrimaryTextField(
                    controller: _minAreaController,
                    text: "Min Area(Sq Ft)",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (upperValue) {
                      int? minArea = int.tryParse(upperValue.replaceAll(",", ""));
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_minAreaKey)) {
                        updateQuery.update(_minAreaKey, (_) => (minArea ?? "").toString());
                      } else {
                        updateQuery[_minAreaKey] = minArea.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Max Area(Sq Ft)",
                  child: PrimaryTextField(
                    controller: _maxAreaController,
                    text: "Max Area(Sq Ft)",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (upperValue) {
                      int? maxArea = int.tryParse(upperValue.replaceAll(",", ""));
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_maxAreaKey)) {
                        updateQuery.update(_maxAreaKey, (_) => (maxArea ?? "").toString());
                      } else {
                        updateQuery[_maxAreaKey] = maxArea.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

//* Amenities section
class _AmenitiesSection extends StatefulWidget {
  _AmenitiesSection({Key? key}) : super(key: key);

  @override
  _AmenitiesSectionState createState() => _AmenitiesSectionState();
}

class _AmenitiesSectionState extends State<_AmenitiesSection> {
  final String _key = "amenities";

  List<int> selectedAmenities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<String> amenityVal = context.vRouter.queryParameters[_key]?.trim().split(",") ?? [];
    selectedAmenities = amenityVal.map((e) => int.parse(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyListingCubit, PropertyListingState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                  updateQuery.remove(_key);
                  _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                  // context.read<PropertyListingCubit>().clearAmenities();
                },
                child: Text(
                  "clear",
                  style: TextStyles.body14.copyWith(color: kDarkGrey, decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.amenities.length,
                  itemBuilder: (context, index) {
                    var e = state.amenities[index];

                    return CheckboxListTile(
                      value: selectedAmenities.contains(e.id),
                      onChanged: (isChecked) {
                        Map<String, String> updateQuery = {...context.vRouter.queryParameters};

                        if (isChecked ?? false) {
                          if (updateQuery.containsKey(_key)) {
                            final amenities = [...selectedAmenities, e.id];
                            updateQuery.update(_key, (value) => amenities.join(","));
                          } else {
                            updateQuery[_key] = [e.id].join(",");
                          }
                        } else {
                          selectedAmenities.removeWhere((element) => element == e.id);
                          if (selectedAmenities.isEmpty) {
                            updateQuery.remove(_key);
                          } else {
                            updateQuery.update(_key, (value) => selectedAmenities.join(","));
                          }
                        }

                        // replace the route
                        _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                      },
                      title: Text(e.name.en),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}

//* Bedroom Bathroom section
class BedroomBathroomSection extends StatefulWidget {
  const BedroomBathroomSection({Key? key}) : super(key: key);

  @override
  State<BedroomBathroomSection> createState() => _BedroomBathroomSectionState();
}

class _BedroomBathroomSectionState extends State<BedroomBathroomSection> {
  final String _minBedroomKey = kMinBedroomKey;
  final String _maxBedroomKey = kMaxBedroomKey;
  final String _minBathKey = kMinBathKey;
  final String _maxBathKey = kMaxBathKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Min Bedroom",
                  child: PrimaryDropdownButton<int>(
                    itemList: bathAndBedCountItems,
                    value: int.tryParse(context.vRouter.queryParameters[_minBedroomKey] ?? ""),
                    onChanged: (value) {
                      int? minBedroom = value;
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_minBedroomKey)) {
                        updateQuery.update(_minBedroomKey, (_) => (minBedroom ?? "").toString());
                      } else {
                        updateQuery[_minBedroomKey] = minBedroom.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                      // context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                    },
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Max Bedroom",
                  child: PrimaryDropdownButton<int>(
                    itemList: bathAndBedCountItems,
                    value: int.tryParse(context.vRouter.queryParameters[_maxBedroomKey] ?? ""),
                    onChanged: (value) {
                      int? maxBedroom = value;
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_maxBedroomKey)) {
                        updateQuery.update(_maxBedroomKey, (_) => (maxBedroom ?? "").toString());
                      } else {
                        updateQuery[_maxBedroomKey] = maxBedroom.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Min Bathroom",
                  child: PrimaryDropdownButton<int>(
                    itemList: bathAndBedCountItems,
                    value: int.tryParse(context.vRouter.queryParameters[_minBathKey] ?? ""),
                    onChanged: (value) {
                      int? minBathroom = value;
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_minBathKey)) {
                        updateQuery.update(_minBathKey, (_) => (minBathroom ?? "").toString());
                      } else {
                        updateQuery[_minBathKey] = minBathroom.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: _Layout(
                  label: "Max Bathroom",
                  child: PrimaryDropdownButton<int>(
                    itemList: bathAndBedCountItems,
                    value: int.tryParse(context.vRouter.queryParameters[_maxBathKey] ?? ""),
                    onChanged: (value) {
                      int? maxBathroom = value;
                      // url updating section
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(_maxBathKey)) {
                        updateQuery.update(_maxBathKey, (_) => (maxBathroom ?? "").toString());
                      } else {
                        updateQuery[_maxBathKey] = maxBathroom.toString();
                      }
                      // replace the route
                      _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

//* Others
class _OthersSection extends StatefulWidget {
  const _OthersSection({Key? key}) : super(key: key);

  @override
  State<_OthersSection> createState() => _OthersSectionState();
}

class _OthersSectionState extends State<_OthersSection> {
  final String _furnishKey = "fn";
  FurnishedType? _furnishedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _furnishedType = context.vRouter.queryParameters[_furnishKey] != null
        ? PropertyModelEnumConverter.furnishedStatusValues.map[context.vRouter.queryParameters[_furnishKey]]
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Layout(
            label: "Furnishing",
            child: PrimaryDropdownButton<FurnishedType>(
              itemList: furnishingListItems,
              value: _furnishedType,
              onChanged: (value) {
                // copy the existing parameters and update with new value
                Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                if (updateQuery.containsKey(_furnishKey)) {
                  updateQuery.update(
                      _furnishKey, (_) => PropertyModelEnumConverter.furnishedStatusValues.reverse![value]!);
                } else {
                  updateQuery[_furnishKey] = PropertyModelEnumConverter.furnishedStatusValues.reverse![value]!;
                }
                // replace the route
                _goto(context: context, path: context.vRouter.path, queryParameters: updateQuery);
                // context.read<PropertyListingCubit>().onFurnishingChanged(value);
              },
            ),
          ),
          SizedBox(height: 15),
          _Layout(
            label: "Tour",
            child: PrimaryDropdownButton(itemList: []),
          ),
        ],
      ),
    );
  }
}
