import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_dropdown_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/request_models/service_enquire_request_model.dart';
import 'package:real_estate_portal/screens/services/components/field_layout.dart';
import 'package:real_estate_portal/screens/services/models/interested_in_model.dart';
import 'package:real_estate_portal/screens/services/models/property_type_model.dart';
import 'package:real_estate_portal/screens/services/models/select_services_model.dart';

Widget _header(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Service Request",
            textAlign: TextAlign.left, style: Responsive.isDesktop(context) ? TS.miniHeaderBlack : MS.lableBlack),
        SizedBox(
          height: 20,
        ),
        Flexible(
          child: Text("Fill the details. Our team will contact you.",
              textAlign: TextAlign.left, style: Responsive.isDesktop(context) ? TS.bodyGray : MS.bodyGray),
        ),
      ],
    ),
  );
}

serviceEnquiryDialog({
  required BuildContext context,
  Function()? onCancel,
  Function(ServiceEnquireRequestParams)? onSubmit,
  required List<DropdownMenuItem<InterestedInModel>> interestedIn,
  required List<DropdownMenuItem<PropertyTypeModel>> propertyType,
  required List<DropdownMenuItem<SelectServicesModel>> selectServiceType,
  required int type,
  String? selectedService,
}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  bool isFirstDropdownSelected = false;
  TextEditingController interestedInText = TextEditingController();
  TextEditingController propertyTypeText = TextEditingController();
  TextEditingController selectServiceText = TextEditingController();
  TextEditingController address = TextEditingController();

  // Starting dropdown is selected logic
  if (type == 4) {
    isFirstDropdownSelected = false;
  } else {
    isFirstDropdownSelected = true;
  }

  // assigning current values
  InterestedInModel? currentValueInterestedIn;
  SelectServicesModel? currentValueServices;
  PropertyTypeModel? currentPropertyType;
  List<DropdownMenuItem<PropertyTypeModel>> filteredPropertyType = [];
  List<DropdownMenuItem<SelectServicesModel>> filteredSelectServiceType = [];

  interestedIn.forEach((element) {
    if (element.value?.type == type) {
      currentValueInterestedIn = element.value;
      isFirstDropdownSelected = true;
    }
  });

  // first taking servies depending on the first dropdown and
  // then assigning current value
  selectServiceType.forEach((element) {
    if (type == 4) {
    } else if (element.value?.type == type) {
      filteredSelectServiceType.add(element);
    }
  });
  // assigning current value from filtered
  filteredSelectServiceType.forEach((element) {
    if (type == 4) {
    } else if (element.value?.type == type) {
      if (selectedService == element.value?.name) {
        currentValueServices = element.value;
      }
    }
  });

  propertyType.forEach((element) {
    if (type == 4) {
    } else if (element.value?.type == type) {
      filteredPropertyType.add(element);
    }
  });

  Column _singleBlock(
      {required String text, required Widget child, double width = double.infinity, double height = 48}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        Container(width: width, height: height, child: child),
      ],
    );
  }

  return showDialog(
      context: context,
      useSafeArea: false,
      barrierLabel: "asd",
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: Center(
              child: Container(
                color: kPlainWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context) ? width / 2 : width - 30,
                      child: Stack(
                        children: [
                          Responsive.isDesktop(context)
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(Insets.xl),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _header(context),
                                          SizedBox(
                                            height: Insets.med,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: FieldLayout(
                                                        caption: "Interested In",
                                                        child: PrimaryDropdownButton<InterestedInModel>(
                                                            itemList: interestedIn,
                                                            hint: 'Select',
                                                            value: type == 4 ? null : currentValueInterestedIn,
                                                            onChanged: (value) {
                                                              print('#selected type = ${value!.type}');
                                                              // setState(() {
                                                              currentValueServices = null;

                                                              // });
                                                              List<DropdownMenuItem<PropertyTypeModel>> property = [];
                                                              List<DropdownMenuItem<SelectServicesModel>> service = [];

                                                              selectServiceType.forEach((element) {
                                                                if (element.value?.type == value.type) {
                                                                  service.add(element);
                                                                }
                                                              });

                                                              propertyType.forEach((element) {
                                                                if (element.value?.type == value.type) {
                                                                  property.add(element);
                                                                }
                                                              });

                                                              print(
                                                                  "values are ==================================================================>");
                                                              print(property.map((e) => e.value?.name).toString());

                                                              isFirstDropdownSelected = true;
                                                              type = value.type;
                                                              filteredPropertyType.clear();
                                                              filteredPropertyType.addAll(property);
                                                              currentPropertyType = null;
                                                              filteredSelectServiceType.clear();
                                                              filteredSelectServiceType.addAll(service);
                                                              currentValueServices = null;
                                                              propertyTypeText.text =
                                                                  filteredPropertyType.first.value!.name;
                                                              selectServiceText.text =
                                                                  filteredSelectServiceType.first.value!.name;
                                                              setState(() {});

                                                              interestedInText.text = value.name;
                                                            }),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: FieldLayout(
                                                        caption: "Property Type",
                                                        child: IgnorePointer(
                                                          ignoring: !isFirstDropdownSelected,
                                                          child: PrimaryDropdownButton<PropertyTypeModel>(
                                                              itemList: filteredPropertyType,
                                                              hint: 'Select',
                                                              value: type == 4
                                                                  ? null
                                                                  : currentPropertyType ??
                                                                      filteredPropertyType.first.value,
                                                              onChanged: (value) {
                                                                if (value == null) return;
                                                                propertyTypeText.text = value.name;
                                                              }),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: IgnorePointer(
                                                        ignoring: !isFirstDropdownSelected,
                                                        child: FieldLayout(
                                                          caption: "Select Services",
                                                          child: PrimaryDropdownButton<SelectServicesModel>(
                                                              itemList: filteredSelectServiceType,
                                                              hint: 'Select',
                                                              value: type == 4
                                                                  ? null
                                                                  : currentValueServices ??
                                                                      filteredSelectServiceType.first.value,
                                                              onChanged: (value) {
                                                                selectServiceText.text = value!.name;
                                                              }),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: _singleBlock(
                                                        height: 100,
                                                        text: "Add Address",
                                                        child: PrimaryTextField(
                                                            text: "",
                                                            minLines: 3,
                                                            maxLines: 5,
                                                            keyboardType: TextInputType.multiline,
                                                            onChanged: (add) {
                                                              address.text = add;
                                                            }),
                                                      ),
                                                    ),
                                                  ]),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: Insets.xl,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          PrimaryButton(
                                            onTap: () {
                                              onCancel!();
                                            },
                                            text: "Cancel",
                                            backgroundColor: kBackgroundColor,
                                            color: kSupportBlue,
                                            height: 45,
                                            width: 110,
                                            fontSize: 12,
                                          ),
                                          SizedBox(
                                            width: Insets.med,
                                          ),
                                          PrimaryButton(
                                            onTap: () {
                                              ServiceEnquireRequestParams requestParams = ServiceEnquireRequestParams(
                                                  interested_in: interestedInText.text,
                                                  property_type: propertyTypeText.text,
                                                  service_name: selectServiceText.text,
                                                  address: address.text);

                                              onSubmit!(requestParams);
                                            },
                                            text: "Submit",
                                            height: 45,
                                            width: 110,
                                            fontSize: 12,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: Insets.xl, bottom: Insets.xl, left: 8, right: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _header(context),
                                          SizedBox(
                                            height: Insets.med,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: FieldLayout(
                                                      caption: "Interested In",
                                                      child: PrimaryDropdownButton<InterestedInModel>(
                                                          itemList: interestedIn,
                                                          hint: 'Select',
                                                          value: currentValueInterestedIn,
                                                          onChanged: (value) {
                                                            print('#selected type = ${value!.type}');
                                                            // setState(() {
                                                            currentValueServices = null;

                                                            // });
                                                            List<DropdownMenuItem<PropertyTypeModel>> property = [];
                                                            List<DropdownMenuItem<SelectServicesModel>> service = [];

                                                            selectServiceType.forEach((element) {
                                                              if (element.value?.type == value.type) {
                                                                service.add(element);
                                                              }
                                                            });

                                                            propertyType.forEach((element) {
                                                              if (element.value?.type == value.type) {
                                                                property.add(element);
                                                              }
                                                            });

                                                            print(
                                                                "values are ==================================================================>");
                                                            print(property.map((e) => e.value?.name).toString());

                                                            isFirstDropdownSelected = true;
                                                            type = value.type;
                                                            filteredPropertyType.clear();
                                                            filteredPropertyType.addAll(property);
                                                            currentPropertyType = null;
                                                            filteredSelectServiceType.clear();
                                                            filteredSelectServiceType.addAll(service);
                                                            currentValueServices = null;
                                                            propertyTypeText.text =
                                                                filteredPropertyType.first.value!.name;
                                                            selectServiceText.text =
                                                                filteredSelectServiceType.first.value!.name;
                                                            setState(() {});

                                                            interestedInText.text = value.name;
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: IgnorePointer(
                                                      ignoring: !isFirstDropdownSelected,
                                                      child: FieldLayout(
                                                        caption: "Property Type",
                                                        child: PrimaryDropdownButton<PropertyTypeModel>(
                                                            itemList: filteredPropertyType,
                                                            hint: 'Select',
                                                            value:
                                                                currentPropertyType ?? filteredPropertyType.first.value,
                                                            onChanged: (value) {
                                                              propertyTypeText.text = value!.name;
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: IgnorePointer(
                                                      ignoring: !isFirstDropdownSelected,
                                                      child: FieldLayout(
                                                        caption: "Select Services",
                                                        child: PrimaryDropdownButton<SelectServicesModel>(
                                                            itemList: filteredSelectServiceType,
                                                            hint: 'Select',
                                                            value: currentValueServices ??
                                                                filteredSelectServiceType.first.value,
                                                            onChanged: (value) {
                                                              selectServiceText.text = value!.name;
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: _singleBlock(
                                                      height: 100,
                                                      text: "Add Address",
                                                      child: PrimaryTextField(
                                                          text: "",
                                                          minLines: 3,
                                                          maxLines: 5,
                                                          keyboardType: TextInputType.multiline,
                                                          onChanged: (add) {
                                                            address.text = add;
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: Insets.xl,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          PrimaryButton(
                                            onTap: () {
                                              onCancel!();
                                            },
                                            text: "Cancel",
                                            backgroundColor: kBackgroundColor,
                                            color: kSupportBlue,
                                            height: 45,
                                            width: 110,
                                            fontSize: 12,
                                          ),
                                          SizedBox(
                                            width: Insets.med,
                                          ),
                                          PrimaryButton(
                                            onTap: () {
                                              ServiceEnquireRequestParams requestParams = ServiceEnquireRequestParams(
                                                  interested_in: interestedInText.text,
                                                  property_type: propertyTypeText.text,
                                                  service_name: selectServiceText.text,
                                                  address: address.text);
                                              onSubmit!(requestParams);
                                            },
                                            text: "Submit",
                                            height: 45,
                                            width: 110,
                                            fontSize: 12,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close, size: 20)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
