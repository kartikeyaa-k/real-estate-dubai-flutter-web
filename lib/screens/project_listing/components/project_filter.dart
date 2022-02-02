import 'dart:convert';

import 'package:easy_text_field/easy_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../../injection_container.dart';
import '../../../models/amenity_model.dart';
import '../../../models/home_page_model/suggest_places_model.dart';
import '../../../services/home/home_services.dart';
import '../constants/project_list_contants.dart';
import '../cubit/project_listing_cubit.dart';

enum FilterType { Search, Keywords, Price, ProjectStatus, Amenities }

const BoxConstraints _kBoxConstraints = BoxConstraints(maxWidth: 320);

_goto({required BuildContext context, required String path, required Map<String, String> queryParameters}) {
  if (queryParameters.containsKey(kProjPageNumberKey)) {
    queryParameters.update(kProjPageNumberKey, (value) => "1");
  } else {
    queryParameters[kProjPageNumberKey] = "1";
  }
  context.vRouter.to(path, isReplacement: true, queryParameters: queryParameters);
}

class ProjectFilter extends StatefulWidget {
  ProjectFilter({Key? key, this.isFullPageView = false, required this.cubit}) : super(key: key);
  final bool isFullPageView;
  final ProjectListingCubit cubit;

  @override
  _ProjectFilterState createState() => _ProjectFilterState();
}

class _ProjectFilterState extends State<ProjectFilter> {
  List<_FilterItem> _filterItems =
      FilterType.values.map((e) => _FilterItem(filterType: e, isExpanded: e == FilterType.Search)).toList();

  @override
  void initState() {
    super.initState();
    widget.cubit.loadAmenities();
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
                Text("Filter Projects", style: TextStyles.h3),
                Spacer(),
                InkWell(
                  onTap: () {
                    // replace the route
                    context.vRouter.to(context.vRouter.path, isReplacement: true);
                    // use bloc
                    context.read<ProjectListingCubit>().clearAllFilters();
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
      case FilterType.ProjectStatus:
        this._title = "Project Status";
        this._widget = _ProjectStatusSection();
        break;
      case FilterType.Amenities:
        this._title = "Amenities";
        this._widget = _AmenitiesSection();
        break;
      default:
        break;
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
  String _key = kProjSearchKeywordKey;

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
  String _keywordsKey = kProjKeywordsKey;
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

  final String _minPriceKey = kProjMinPriceKey;
  final String _maxPriceKey = kProjMaxPriceKey;

  String? _minPrice;
  String? _maxPrice;

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
  final String _key = kProjAmenities;

  List<int> selectedAmenities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<String> amenityVal = context.vRouter.queryParameters[_key]?.trim().split(",") ?? [];
    selectedAmenities = amenityVal.map((e) => int.parse(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectListingCubit, ProjectListingState>(
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

//* Property Status section

class _ProjectStatusSection extends StatefulWidget {
  const _ProjectStatusSection({Key? key}) : super(key: key);

  @override
  _ProjectStatusSectionState createState() => _ProjectStatusSectionState();
}

class _ProjectStatusSectionState extends State<_ProjectStatusSection> {
  List<int> _years = List.generate(6, (index) => DateTime.now().year + index);
  int? _deliveryYear;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deliveryYear = int.tryParse(context.vRouter.queryParameters[_deliveryYear] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Layout(
            label: "Delivery Date",
            child: PrimaryDropdownButton<int>(
              itemList: _years.map((e) => DropdownMenuItem<int>(child: Text("from $e"), value: e)).toList(),
              value: _deliveryYear,
              onChanged: (value) {
                final _key = kProjDeliveryDateKey;
                // copy the existing parameters and update with new value
                Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                if (updateQuery.containsKey(_key)) {
                  updateQuery.update(_key, (_) => value.toString());
                } else {
                  updateQuery[_key] = value.toString();
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
