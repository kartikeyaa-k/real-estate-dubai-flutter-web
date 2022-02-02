import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:real_estate_portal/components/dialogs/service_provider_success_dialog.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../components/buttons/primary_button.dart';
// import '../../components/breadcrumb/primary_breadcrumb.dart';
import '../../components/footer.dart';
import '../../components/input_fields/primary_dropdown_button.dart';
import '../../components/input_fields/primary_text_field.dart';
import '../../components/mobile_padding.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/snack_bar/custom_snack_bar.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/request_models/add_service_agency_model.dart';
import '../../models/request_models/new_requested_service_model.dart';
import '../../models/response_models/emirate_list_models/emirate_model.dart';
import '../../models/response_models/organisation_types_models/organisation_types_model.dart';
import '../../models/response_models/service_list_models/service_model.dart';
import '../../models/response_models/service_list_models/service_name_model.dart';
import '../../routes/routes.dart';
import 'components/add_service_dialog.dart';
import 'components/field_layout.dart';
import 'components/form_components.dart';
import 'components/mobile_body.dart';
import 'cubit/service_provider_cubit.dart';

class ChoosenServiceModel {
  int no;
  String name;
  bool isNewRequestedServices;
  String serviceType;
  ChoosenServiceModel(
      {required this.no,
      required this.name,
      this.isNewRequestedServices = false,
      this.serviceType =
          'FACILITY_MANAGEMENT_SERVICE'});
}

class ServiceRegistrationScreen
    extends StatelessWidget {
  const ServiceRegistrationScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceRegistrationView();
  }
}

class ServiceRegistrationView
    extends StatefulWidget {
  const ServiceRegistrationView({Key? key})
      : super(key: key);

  @override
  State<ServiceRegistrationView> createState() =>
      _ServiceRegistrationViewState();
}

class _ServiceRegistrationViewState
    extends State<ServiceRegistrationView>
    with TickerProviderStateMixin {
  final _cubit = sl<ServiceProviderCubit>();
  int _formIndex = 0;
  TextEditingController _firstNameField =
      TextEditingController();
  TextEditingController _lastNameField =
      TextEditingController();
  TextEditingController _emailField =
      TextEditingController();
  TextEditingController _mobileField =
      TextEditingController();
  TextEditingController _companyInfo =
      TextEditingController();
  TextEditingController _registredOfficeAddress =
      TextEditingController();
  List<DropdownMenuItem<OrganisationTypesModel>>
      _typeOfOrganizationDropdown = [];
  OrganisationTypesModel? organisationTypesModel;

  TextEditingController _typeOfOrganizationField =
      TextEditingController();

  List<DropdownMenuItem<ServiceModel>>
      _facilityServicesDropdown = [];
  List<DropdownMenuItem<ServiceModel>>
      _tempFacilityServicesDropdown = [];
  ServiceModel? facilityServicesModel;
  ChoosenServiceModel?
      _facilityServicesDropdownCurrentValue;

  List<DropdownMenuItem<ServiceModel>>
      _otherServicesDropdown = [];

  ServiceModel? otherServicesModel;
  ChoosenServiceModel?
      _otherServicesDropdownCurrentValue;
  bool isFacilityAdded = false;
  bool isOtherServiceAdded = false;
  List<MultiSelectItem<EmirateModel>>
      _multiSelect = [];
  List<NewRequestedServiceRequestParams>
      _newRequestedServices = [];
  EmirateModel? emirateModel;
  TextEditingController _emiratesField =
      TextEditingController();
  List<EmirateModel?> emirateList = [];
  late TabController _tabController;
  String _service_provider_type = 'BOTH';
  bool _facility_management_service_checkbox =
      true;
  bool _other_services_checkbox = true;
  List<ChoosenServiceModel> _choosen_services =
      [];
  List<ChoosenServiceModel>
      _choosen_facility_services = [];
  List<ChoosenServiceModel>
      _choosen_other_services = [];
  StepState _basicInfoStepState =
      StepState.editing;
  StepState _companyInfoStepState =
      StepState.indexed;
  StepState _propertyInfoStepState =
      StepState.indexed;
  StepState _amcStepState = StepState.indexed;

  int _index = 0;

  // Visibility var
  bool isLoading = true;

  @override
  void initState() {
    _facilityServicesDropdown
        .add(DropdownMenuItem(
      value: ServiceModel(
          service_id: -1,
          service_name:
              ServiceNameModel(en: 'a', ar: 'a')),
      child: Text("+ Add New Faciity Service"),
    ));

    _otherServicesDropdown.add(DropdownMenuItem(
      value: ServiceModel(
          service_id: -1,
          service_name:
              ServiceNameModel(en: 'a', ar: 'a')),
      child: Text("+ Add New Other Service"),
    ));
    loadUserData();
    loadServiceList();
    _tabController =
        TabController(length: 2, vsync: this);

    super.initState();
  }

  void loadUserData() {
    User? user =
        FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Redirect to Login
      debugPrint('#log : User not logged in');
    } else {
      String? _displayName = FirebaseAuth
          .instance.currentUser?.displayName;
      debugPrint(
          '#log : User logged in as $_displayName');

      String? _emailName = FirebaseAuth
          .instance.currentUser?.email;
      String? _mobileNumber = FirebaseAuth
          .instance.currentUser?.phoneNumber;
      _firstNameField.text =
          _displayName?.split(',').first ?? "";
      _lastNameField.text =
          _displayName?.split(',').last ?? "";
      _emailField.text = _emailName ?? "";
      _mobileField.text = _mobileNumber ?? "";
    }
  }

  void loadServiceList() {
    _cubit.getOrganisationTypesList();
    _cubit.getServiceListForFacility();
    _cubit.getServiceListForOther();
    _cubit.getEmiratesList();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameField.dispose();
    _lastNameField.dispose();
    _emailField.dispose();
    _mobileField.dispose();
    _companyInfo.dispose();
    _registredOfficeAddress.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    if (!context.vRouter.queryParameters.keys
        .contains("other_service_name")) {
    } else {
      String new_requested_services =
          context.vRouter.queryParameters[
              "other_service_name"] as String;
      print('#log : $new_requested_services');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    Widget _vSpace = Responsive(
        mobile: SizedBox(height: Insets.med),
        tablet: SizedBox(height: Insets.xl),
        desktop: SizedBox(height: Insets.xxl));
    double _oldOffset =
        Responsive.isDesktop(context)
            ? Insets.oldOffset
            : 0;

    Column _singleBlock(
        {required String text,
        required Widget child,
        double width = double.infinity,
        double height = 48}) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(text,
              style: TextStyles.body14
                  .copyWith(color: kLightBlue)),
          SizedBox(height: 4),
          Container(
              width: width,
              height: height,
              child: child),
        ],
      );
    }

    // Dynamic

    Widget _formButtons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            if (_formIndex != 0) {
              setState(() {
                _formIndex--;
              });
            }
          },
          text: _formIndex > 0
              ? "Previous"
              : "Cancel",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
        SizedBox(
          width: Insets.xl,
        ),
        PrimaryButton(
          onTap: () {
            if (_formIndex == 0) {
              setState(() {
                _formIndex++;
              });
            } else if (_formIndex == 1) {
              if (_companyInfo.text == '' ||
                  _registredOfficeAddress.text ==
                      '' ||
                  organisationTypesModel ==
                      null ||
                  emirateList.isEmpty) {
                print(
                    '#log : Form Index 1 Validation Failed');
                SnackBar snackBar =
                    CustomSnackBar.errorSnackBar(
                        'All fields are compulsory');

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else {
                setState(() {
                  _formIndex++;
                });
              }
            } else if (_formIndex == 2) {
              if (_choosen_services.isEmpty) {
                print(
                    '#log : Form Index 2 Validation Failed');

                SnackBar snackBar =
                    CustomSnackBar.errorSnackBar(
                        'All fields are compulsory');

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else {
                List<int> list = [];
                String serviceProviderType = '';
                if (isFacilityAdded &&
                    isOtherServiceAdded) {
                  serviceProviderType = 'BOTH';
                } else if (isFacilityAdded) {
                  serviceProviderType =
                      'FACILITY_MANAGEMENT_SERVICE';
                } else if (isOtherServiceAdded) {
                  serviceProviderType =
                      'OTHER_SERVICE';
                }
                _choosen_services
                    .forEach((element) {
                  if (element
                      .isNewRequestedServices) {
                    _newRequestedServices.add(
                        NewRequestedServiceRequestParams(
                            serviceName:
                                element.name,
                            serviceType: element
                                .serviceType));
                  } else {
                    list.add(element.no);
                  }
                });
                AddServiceAgencyRequestParams
                    requestParams =
                    AddServiceAgencyRequestParams(
                        companyName:
                            _companyInfo.text,
                        typeOfOrganization:
                            organisationTypesModel!
                                .key,
                        registeredOfficeAddress:
                            _registredOfficeAddress
                                .text,
                        emirateIds: emirateList
                            .map((e) =>
                                (e!.emirate_id))
                            .toList(),
                        serviceProviderType:
                            serviceProviderType,
                        chosenServices: list,
                        newRequestedServices:
                            _newRequestedServices);

                _cubit.addServiceAgency(
                    requestParams);
              }
            }
          },
          text:
              _formIndex == 2 ? "Submit" : "Next",
          height: 45,
          width: 110,
          fontSize: 12,
          color: (_choosen_services.isEmpty)
              ? _formIndex == 2
                  ? kBlackVariant
                  : kPlainWhite
              : kPlainWhite,
          backgroundColor:
              (_choosen_services.isEmpty)
                  ? _formIndex == 2
                      ? kDisableColor
                      : kSupportBlue
                  : kSupportBlue,
        ),
        SizedBox(
          width: Insets.oldOffset,
        ),
      ],
    );

    Widget _choosenServices(
        ChoosenServiceModel model, int index) {
      return Container(
        padding: EdgeInsets.only(bottom: hp(2)),
        child: Row(children: [
          Container(
            width: wp(6),
            child: Text(
              (index + 1).toString(),
              style: TextStyles.h4,
            ),
          ),
          Container(
            width: wp(20),
            child: Text(
              model.name,
              style: TextStyles.h4,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                print(model.serviceType);
                if (model.serviceType ==
                        'OTHER_SERVICE' ||
                    model.serviceType ==
                        'OTHER_SERVICE_DROPDOWN') {
                  _choosen_other_services
                      .removeAt(index);
                } else {
                  _choosen_facility_services
                      .removeAt(index);
                }
                _choosen_services.removeAt(index);
              });
            },
            child: Container(
              padding: EdgeInsets.all(Insets.sm),
              decoration: BoxDecoration(
                border: Border.all(
                    color: kErrorColor),
                borderRadius:
                    BorderRadius.circular(2),
              ),
              child: Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
            ),
          ),
        ]),
      );
    }

    Widget _facilityManagementTabView = Column(
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FieldLayout(
                caption:
                    "Choose the Facility Management Service",
                child: PrimaryDropdownButton<
                        ServiceModel>(
                    itemList:
                        _facilityServicesDropdown,
                    hint: 'Select',
                    value: facilityServicesModel,
                    onChanged: (value) {
                      if (value?.service_id ==
                          -1) {
                        addNewServiceDialog(
                            context: context,
                            onAdd: (serviceName) {
                              Navigator.of(
                                      context)
                                  .pop();
                              setState(() {
                                _choosen_services.add(ChoosenServiceModel(
                                    no: _choosen_services.length +
                                        1,
                                    name:
                                        serviceName,
                                    isNewRequestedServices:
                                        true,
                                    serviceType:
                                        'FACILITY_MANAGEMENT_SERVICE'));
                                _choosen_facility_services.add(ChoosenServiceModel(
                                    no: _choosen_services.length +
                                        1,
                                    name:
                                        serviceName,
                                    isNewRequestedServices:
                                        true,
                                    serviceType:
                                        'FACILITY_MANAGEMENT_SERVICE'));
                              });
                            });
                      } else
                        setState(() {
                          _facilityServicesDropdownCurrentValue =
                              ChoosenServiceModel(
                                  no: value!
                                      .service_id,
                                  name: value
                                      .service_name!
                                      .en,
                                  isNewRequestedServices:
                                      false,
                                  serviceType:
                                      'FACILITY_MANAGEMENT_SERVICE');
                        });
                    }),
              ),
            ),
            SizedBox(
              width: Insets.xl,
            ),
            SizedBox(
              width: 100,
              child: PrimaryButton(
                onTap: () {
                  if (_choosen_services
                      .isNotEmpty) {
                    bool exists = false;

                    _choosen_services
                        .forEach((element) {
                      if (element.name ==
                          _facilityServicesDropdownCurrentValue
                              ?.name) {
                        exists = true;
                        final errorSnackBar =
                            CustomSnackBar
                                .errorSnackBar(
                                    "This service is already added.");
                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                                errorSnackBar)
                            .closed
                            .then((value) =>
                                ScaffoldMessenger
                                        .of(context)
                                    .clearSnackBars());
                      }
                    });
                    if (_facilityServicesDropdownCurrentValue !=
                            null &&
                        !exists) {
                      setState(() {
                        _choosen_services.add(
                            _facilityServicesDropdownCurrentValue!);
                        _choosen_facility_services
                            .add(
                                _facilityServicesDropdownCurrentValue!);
                      });
                    }
                  } else {
                    if (_facilityServicesDropdownCurrentValue !=
                        null) {
                      setState(() {
                        _choosen_services.add(
                            _facilityServicesDropdownCurrentValue!);
                        _choosen_facility_services
                            .add(
                                _facilityServicesDropdownCurrentValue!);
                      });
                    }
                  }
                },
                text: 'Add',
              ),
            )
          ],
        ),
        SizedBox(
          height: Insets.xl,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(Insets.sm,
              Insets.xl, Insets.sm, Insets.xl),
          decoration: BoxDecoration(
            color: kPlainWhite,
            borderRadius:
                BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: wp(6),
                    child: Text(
                      'No.',
                      style: TextStyles.h4,
                    ),
                  ),
                  Container(
                    width: wp(10),
                    child: Text(
                      'Service',
                      style: TextStyles.h4,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Insets.xl,
              ),
              Container(
                height: hp(20),
                child: ListView.builder(
                    itemCount:
                        _choosen_facility_services
                            .length,
                    itemBuilder:
                        (BuildContext ctx,
                            int i) {
                      if (_choosen_facility_services[
                                      i]
                                  .serviceType ==
                              'FACILITY_MANAGEMENT_SERVICE' ||
                          _choosen_facility_services[
                                      i]
                                  .serviceType ==
                              'FACILITY_MANAGEMENT_SERVICE') {
                        return _choosenServices(
                            _choosen_facility_services[
                                i],
                            i);
                      } else {
                        return Container();
                      }
                    }),
              ),
              SizedBox(
                height: Insets.xl,
              ),
            ],
          ),
        )
      ],
    );

    Widget _otherServicesTabView = Column(
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FieldLayout(
                caption:
                    "Choose the Other Service",
                child: PrimaryDropdownButton<
                        ServiceModel>(
                    itemList:
                        _otherServicesDropdown,
                    value: otherServicesModel,
                    hint: "Select",
                    onChanged: (value) {
                      if (value?.service_id ==
                          -1) {
                        addNewServiceDialog(
                            context: context,
                            onAdd: (serviceName) {
                              Navigator.of(
                                      context)
                                  .pop();
                              setState(() {
                                _choosen_services.add(ChoosenServiceModel(
                                    no: _choosen_services.length +
                                        1,
                                    name:
                                        serviceName,
                                    isNewRequestedServices:
                                        true,
                                    serviceType:
                                        'OTHER_SERVICE'));
                                        
                                _choosen_other_services.add(ChoosenServiceModel(
                                    no: _choosen_services.length +
                                        1,
                                    name:
                                        serviceName,
                                    isNewRequestedServices:
                                        true,
                                    serviceType:
                                        'OTHER_SERVICE'));
                              });
                            });
                      } else
                        setState(() {
                          _otherServicesDropdownCurrentValue =
                              ChoosenServiceModel(
                                  no: value!
                                      .service_id,
                                  name: value
                                      .service_name!
                                      .en,
                                  isNewRequestedServices:
                                      true,
                                  serviceType:
                                      'OTHER_SERVICE');
                        });
                    }),
              ),
            ),
            SizedBox(
              width: Insets.xl,
            ),
            SizedBox(
              width: 100,
              child: PrimaryButton(
                onTap: () {
                  if (_choosen_services
                      .isNotEmpty) {
                    bool exists = false;

                    _choosen_services
                        .forEach((element) {
                      if (element.name ==
                          _otherServicesDropdownCurrentValue
                              ?.name) {
                        exists = true;
                        final errorSnackBar =
                            CustomSnackBar
                                .errorSnackBar(
                                    "This service is already added.");
                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                                errorSnackBar)
                            .closed
                            .then((value) =>
                                ScaffoldMessenger
                                        .of(context)
                                    .clearSnackBars());
                      }
                    });
                    if (_otherServicesDropdownCurrentValue !=
                            null &&
                        !exists) {
                      setState(() {
                        _choosen_services.add(
                            _otherServicesDropdownCurrentValue!);
                        _choosen_other_services.add(
                            _otherServicesDropdownCurrentValue!);
                      });
                    }
                  } else {
                    if (_otherServicesDropdownCurrentValue !=
                        null) {
                      setState(() {
                        _choosen_services.add(
                            _otherServicesDropdownCurrentValue!);
                        _choosen_other_services.add(
                            _otherServicesDropdownCurrentValue!);
                      });
                    }
                  }
                  // context.vRouter.to(AddServiceDialogPath);
                },
                text: 'Add',
              ),
            )
          ],
        ),
        SizedBox(
          height: Insets.xl,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(Insets.sm,
              Insets.xl, Insets.sm, Insets.xl),
          decoration: BoxDecoration(
            color: kPlainWhite,
            borderRadius:
                BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: wp(6),
                    child: Text(
                      'No.',
                      style: TextStyles.h4,
                    ),
                  ),
                  Container(
                    width: wp(10),
                    child: Text(
                      'Service',
                      style: TextStyles.h4,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Insets.xl,
              ),
              Container(
                height: hp(20),
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          _choosen_other_services
                              .length,
                      itemBuilder:
                          (BuildContext ctx,
                              int i) {
                        if (_choosen_other_services[
                                        i]
                                    .serviceType ==
                                'OTHER_SERVICE' ||
                            _choosen_other_services[
                                        i]
                                    .serviceType ==
                                'OTHER_SERVICE') {
                          return _choosenServices(
                              _choosen_other_services[
                                  i],
                              i);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
              SizedBox(
                height: Insets.xl,
              ),
            ],
          ),
        )
      ],
    );

    Widget _formFirst = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              FormComponents
                  .leftFormStatusDisplay(
                      context, 0),
              SizedBox(
                width:
                    Responsive.isDesktop(context)
                        ? Insets.oldOffset
                        : Insets.med,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(
                    left: Insets.oldOffset,
                    top: Insets.xxl,
                    bottom: Insets.xxl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: kBlackVariant
                        .withOpacity(0.1),
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text('Basic Information',
                            textAlign:
                                TextAlign.center,
                            style: TextStyles.h5
                                .copyWith(
                                    color:
                                        kBlackVariant)),
                        SizedBox(
                          height:
                              Insets.oldOffset,
                        ),
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            _singleBlock(
                              text: "First Name",
                              width: 280,
                              child:
                                  PrimaryTextField(
                                      enabled:
                                          false,
                                      controller:
                                          _firstNameField,
                                      text:
                                          "John",
                                      onChanged:
                                          (firstName) {
                                        // _firstNameField.text = firstName;
                                      }),
                            ),
                            SizedBox(
                              width: Insets
                                  .oldOffset,
                            ),
                            _singleBlock(
                              text: "Last Name",
                              width: 280,
                              child:
                                  PrimaryTextField(
                                      enabled:
                                          false,
                                      text:
                                          "Williamson",
                                      controller:
                                          _lastNameField,
                                      onChanged:
                                          (lastName) {
                                        // _lastNameField.text = lastName;
                                      }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height:
                              Insets.oldOffset,
                        ),
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            _singleBlock(
                              text: "Email ID",
                              width: 280,
                              child: PrimaryTextField(
                                  enabled: false,
                                  text:
                                      "joe@example.com",
                                  controller:
                                      _emailField,
                                  onChanged:
                                      (firstName) {}),
                            ),
                            SizedBox(
                              width: Insets
                                  .oldOffset,
                            ),
                            _singleBlock(
                              text: "Mobile No.",
                              width: 280,
                              child: PrimaryTextField(
                                  enabled: false,
                                  text:
                                      "54545455",
                                  controller:
                                      _mobileField,
                                  onChanged:
                                      (firstName) {}),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Insets.oldOffset,
                    ),
                    _formButtons
                  ],
                ),
              ))
            ],
          )
        ]);

    Widget _formTwo = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              FormComponents
                  .leftFormStatusDisplay(
                      context, 1),
              SizedBox(
                width:
                    Responsive.isDesktop(context)
                        ? Insets.oldOffset
                        : Insets.med,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(
                    left: Insets.oldOffset,
                    top: Insets.xxl,
                    right: Insets.oldOffset,
                    bottom: Insets.xxl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: kBlackVariant
                        .withOpacity(0.1),
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Company Information',
                              textAlign: TextAlign
                                  .center,
                              style: TextStyles.h5
                                  .copyWith(
                                      color:
                                          kBlackVariant)),
                          SizedBox(
                            height:
                                Insets.oldOffset,
                          ),
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              _singleBlock(
                                text:
                                    "Company Name",
                                width: 280,
                                child: PrimaryTextField(
                                    controller:
                                        _companyInfo,
                                    text: "",
                                    onChanged:
                                        (name) {}),
                              ),
                              SizedBox(
                                width: Insets
                                    .oldOffset,
                              ),
                              Expanded(
                                child:
                                    FieldLayout(
                                  caption:
                                      "Type of Organisation",
                                  child: PrimaryDropdownButton<
                                          OrganisationTypesModel>(
                                      itemList:
                                          _typeOfOrganizationDropdown,
                                      hint:
                                          'Select',
                                      value:
                                          organisationTypesModel,
                                      onChanged:
                                          (value) {
                                        setState(
                                            () {
                                          organisationTypesModel =
                                              value;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                                Insets.oldOffset,
                          ),
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Expanded(
                                child:
                                    _singleBlock(
                                  height: 100,
                                  text:
                                      "Registered Office Address",
                                  child: PrimaryTextField(
                                      controller:
                                          _registredOfficeAddress,
                                      text: "",
                                      minLines: 3,
                                      maxLines: 5,
                                      keyboardType:
                                          TextInputType
                                              .multiline,
                                      onChanged:
                                          (add) {}),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                                Insets.oldOffset,
                          ),
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .start,
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children: [
                                SizedBox(
                                  width: 380,
                                  child: MultiSelectDialogField<
                                      EmirateModel?>(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                kSupportBlue),
                                        borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(4))),
                                    buttonIcon: Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        color:
                                            kSupportBlue),
                                    items:
                                        _multiSelect,
                                    listType:
                                        MultiSelectListType
                                            .LIST,
                                    searchable:
                                        true,
                                    initialValue:
                                        null,
                                    searchIcon: Icon(
                                        Icons
                                            .search,
                                        color:
                                            kSupportBlue),
                                    buttonText: Text(
                                        "Select Emirates",
                                        style: TextStyles
                                            .body16
                                            .copyWith(
                                                color: kDarkGrey)),
                                    selectedColor:
                                        kSupportBlue,
                                    selectedItemsTextStyle:
                                        TextStyle(
                                            color:
                                                kSupportBlue),
                                    onConfirm:
                                        (list) {
                                      setState(
                                          () {
                                        emirateList =
                                            list;
                                      });
                                    },
                                  ),
                                )
                              ]),
                        ],
                      ),
                      SizedBox(
                        height: Insets.oldOffset,
                      ),
                      _formButtons
                    ],
                  ),
                ),
              ))
            ],
          ),
        ]);

    Widget _formThree = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                FormComponents
                    .leftFormStatusDisplay(
                        context, 2),
                SizedBox(
                  width: Responsive.isDesktop(
                          context)
                      ? Insets.oldOffset
                      : Insets.med,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(
                      left: Insets.oldOffset,
                      top: Insets.xl,
                      bottom: Insets.xxl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: kBlackVariant
                          .withOpacity(0.1),
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Choose the service',
                              textAlign: TextAlign
                                  .center,
                              style: TextStyles.h5
                                  .copyWith(
                                      color:
                                          kBlackVariant)),
                          SizedBox(
                            height:
                                Insets.oldOffset,
                          ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     _singleBlock(
                          //       text: "Select Service Provider Type",
                          //       width: 280,
                          //       child: CheckboxListTile(
                          //         value: _facility_management_service_checkbox,
                          //         contentPadding: EdgeInsets.zero,
                          //         dense: true,
                          //         controlAffinity: ListTileControlAffinity.leading,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             _facility_management_service_checkbox = !_facility_management_service_checkbox;
                          //           });
                          //         },
                          //         title: Text("Facility Management", style: TextStyles.body16),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: Insets.oldOffset,
                          //     ),
                          //     _singleBlock(
                          //       text: "",
                          //       width: 280,
                          //       child: CheckboxListTile(
                          //         contentPadding: EdgeInsets.zero,
                          //         value: _other_services_checkbox,
                          //         dense: true,
                          //         controlAffinity: ListTileControlAffinity.leading,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             _other_services_checkbox = !_other_services_checkbox;
                          //           });
                          //         },
                          //         title: Text("Other Services", style: TextStyles.body16),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          Container(
                              margin: EdgeInsets.only(
                                  right: Insets
                                      .oldOffset),
                              height: hp(64.4),
                              decoration:
                                  BoxDecoration(
                                color: kGrayCard,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            12),
                              ),
                              child: Column(
                                children: [
                                  TabBar(
                                    controller:
                                        _tabController,
                                    tabs: [
                                      Text(
                                          'Facility Management'),
                                      Text(
                                          'Other Services')
                                    ],
                                    indicatorColor:
                                        kSupportBlue,
                                    labelColor:
                                        Colors
                                            .black,
                                    unselectedLabelColor:
                                        kBlackVariant,
                                    labelStyle: TextStyles
                                        .h4
                                        .copyWith(
                                            color:
                                                kBlackVariant),
                                    indicatorWeight:
                                        3,
                                    labelPadding:
                                        EdgeInsets.symmetric(
                                            horizontal:
                                                2,
                                            vertical:
                                                20),
                                    padding:
                                        EdgeInsets
                                            .only(
                                      right: Insets
                                              .oldOffset *
                                          6,
                                      left: Insets
                                          .sm,
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                        Container(
                                      padding: EdgeInsets.fromLTRB(
                                          Insets
                                              .sm,
                                          Insets
                                              .xl,
                                          Insets
                                              .sm,
                                          Insets
                                              .xl),
                                      width: double
                                          .infinity,
                                      child:
                                          TabBarView(
                                        controller:
                                            _tabController,
                                        children: [
                                          _facilityManagementTabView,
                                          _otherServicesTabView
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: Insets.oldOffset,
                      ),
                      _formButtons
                    ],
                  ),
                )),
              ])
        ]);

// ********************************** Mobile Forms **********************************

    Widget _mobileformButtons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            if (_formIndex != 0) {
              setState(() {
                _formIndex--;
              });
            }
          },
          text: _formIndex > 0
              ? "Previous"
              : "Cancel",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
        mobileHorizontalSizedBox,
        PrimaryButton(
          onTap: () {
            if (_formIndex == 0) {
              setState(() {
                _formIndex++;
              });
            } else if (_formIndex == 1) {
              if (_companyInfo.text == '' ||
                  _registredOfficeAddress.text ==
                      '' ||
                  organisationTypesModel ==
                      null ||
                  emirateList.isEmpty) {
                print(
                    '#log : Form Index 1 Validation Failed');
                SnackBar snackBar =
                    CustomSnackBar.errorSnackBar(
                        'All fields are compulsory');

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else {
                setState(() {
                  _formIndex++;
                });
              }
            } else if (_formIndex == 2) {
              if (_choosen_services.isEmpty) {
                print(
                    '#log : Form Index 2 Validation Failed');

                SnackBar snackBar =
                    CustomSnackBar.errorSnackBar(
                        'All fields are compulsory');

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else {
                List<int> list = [];
                String serviceProviderType = '';
                if (isFacilityAdded &&
                    isOtherServiceAdded) {
                  serviceProviderType = 'BOTH';
                } else if (isFacilityAdded) {
                  serviceProviderType =
                      'FACILITY_MANAGEMENT_SERVICE';
                } else if (isOtherServiceAdded) {
                  serviceProviderType =
                      'OTHER_SERVICE';
                }
                _choosen_services
                    .forEach((element) {
                  if (element
                      .isNewRequestedServices) {
                    _newRequestedServices.add(
                        NewRequestedServiceRequestParams(
                            serviceName:
                                element.name,
                            serviceType: element
                                .serviceType));
                  } else {
                    list.add(element.no);
                  }
                });
                AddServiceAgencyRequestParams
                    requestParams =
                    AddServiceAgencyRequestParams(
                        companyName:
                            _companyInfo.text,
                        typeOfOrganization:
                            organisationTypesModel!
                                .key,
                        registeredOfficeAddress:
                            _registredOfficeAddress
                                .text,
                        emirateIds: emirateList
                            .map((e) =>
                                (e!.emirate_id))
                            .toList(),
                        serviceProviderType:
                            serviceProviderType,
                        chosenServices: list,
                        newRequestedServices:
                            _newRequestedServices);

                _cubit.addServiceAgency(
                    requestParams);
              }
            }
          },
          text:
              _formIndex == 2 ? "Submit" : "Next",
          height: 45,
          width: 110,
          fontSize: 12,
          color: (_choosen_services.isEmpty)
              ? _formIndex == 2
                  ? kBlackVariant
                  : kPlainWhite
              : kPlainWhite,
          backgroundColor:
              (_choosen_services.isEmpty)
                  ? _formIndex == 2
                      ? kDisableColor
                      : kSupportBlue
                  : kSupportBlue,
        ),
      ],
    );

    Widget _mobileChoosenServices(
        ChoosenServiceModel model, int index) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            bottom: hp(1),
            left: mobileLeftRightPadding,
            right: mobileLeftRightPadding,
            top: mobileLeftRightPadding),
        child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Container(
                width: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                    (index + 1).toString(),
                    style: TextStyles.h4,
                    textAlign: TextAlign.left),
              ),
              Expanded(
                child: Text(
                  model.name,
                  style: TextStyles.h4,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    print(model.serviceType);
                    if (model.serviceType ==
                            'OTHER_SERVICE' ||
                        model.serviceType ==
                            'OTHER_SERVICE_DROPDOWN') {
                      _choosen_other_services
                          .removeAt(index);
                    } else {
                      _choosen_facility_services
                          .removeAt(index);
                    }
                    _choosen_services
                        .removeAt(index);
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: kErrorColor),
                    borderRadius:
                        BorderRadius.circular(2),
                  ),
                  child: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                    size: 14,
                  ),
                ),
              ),
            ]),
      );
    }

    Widget _mobileFacilityManagementTabView =
        Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: mobileLeftRightPadding,
              bottom: mobileLeftRightPadding),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FieldLayout(
                  caption:
                      "Choose the Facility Management Service",
                  child: PrimaryDropdownButton<
                          ServiceModel>(
                      itemList:
                          _facilityServicesDropdown,
                      hint: 'Select',
                      value:
                          facilityServicesModel,
                      onChanged: (value) {
                        if (value?.service_id ==
                            -1) {
                          addNewServiceDialog(
                              context: context,
                              onAdd:
                                  (serviceName) {
                                Navigator.of(
                                        context)
                                    .pop();
                                setState(() {
                                  _choosen_services.add(ChoosenServiceModel(
                                      no: _choosen_services
                                              .length +
                                          1,
                                      name:
                                          serviceName,
                                      isNewRequestedServices:
                                          true,
                                      serviceType:
                                          'FACILITY_MANAGEMENT_SERVICE'));

                                  _choosen_facility_services.add(ChoosenServiceModel(
                                      no: _choosen_services
                                              .length +
                                          1,
                                      name:
                                          serviceName,
                                      isNewRequestedServices:
                                          true,
                                      serviceType:
                                          'FACILITY_MANAGEMENT_SERVICE'));
                                });
                              });
                        } else
                          setState(() {
                            _facilityServicesDropdownCurrentValue =
                                ChoosenServiceModel(
                                    no: value!
                                        .service_id,
                                    name: value
                                        .service_name!
                                        .en,
                                    isNewRequestedServices:
                                        false,
                                    serviceType:
                                        'FACILITY_DROPDOWN');
                          });
                      }),
                ),
              ),
              mobileHorizontalSizedBox,
              SizedBox(
                width: 70,
                child: PrimaryButton(
                  onTap: () {
                    if (_choosen_services
                        .isNotEmpty) {
                      bool exists = false;

                      _choosen_services
                          .forEach((element) {
                        if (element.name ==
                            _facilityServicesDropdownCurrentValue
                                ?.name) {
                          exists = true;
                          final errorSnackBar =
                              CustomSnackBar
                                  .errorSnackBar(
                                      "This service is already added.");
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                                  errorSnackBar)
                              .closed
                              .then((value) =>
                                  ScaffoldMessenger.of(
                                          context)
                                      .clearSnackBars());
                        }
                      });
                      if (_facilityServicesDropdownCurrentValue !=
                              null &&
                          !exists) {
                        setState(() {
                          _choosen_services.add(
                              _facilityServicesDropdownCurrentValue!);
                          _choosen_facility_services
                              .add(
                                  _facilityServicesDropdownCurrentValue!);
                        });
                      }
                    } else {
                      if (_facilityServicesDropdownCurrentValue !=
                          null) {
                        setState(() {
                          _choosen_services.add(
                              _facilityServicesDropdownCurrentValue!);
                          _choosen_facility_services
                              .add(
                                  _facilityServicesDropdownCurrentValue!);
                        });
                      }
                    }
                  },
                  text: 'Add',
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: kPlainWhite,
            borderRadius:
                BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(
              mobileLeftRightPadding),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: mobileLeftRightPadding,
                    right:
                        mobileLeftRightPadding),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      // decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        'No.',
                        style:
                            MS.miniestHeaderBlack,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(border: Border.all()),
                        child: Text(
                          'Service',
                          style: TextStyles.h4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              mobileVerticalSizedBox,
              Container(
                height: hp(24),
                color: kBackgroundColor,
                child: ListView.builder(
                    itemCount:
                        _choosen_facility_services
                            .length,
                    itemBuilder:
                        (BuildContext ctx,
                            int i) {
                      if (_choosen_facility_services[
                                      i]
                                  .serviceType ==
                              'FACILITY_DROPDOWN' ||
                          _choosen_facility_services[
                                      i]
                                  .serviceType ==
                              'FACILITY_MANAGEMENT_SERVICE') {
                        return _mobileChoosenServices(
                            _choosen_facility_services[
                                i],
                            i);
                      } else {
                        return Container();
                      }
                    }),
              ),
              SizedBox(
                height: Insets.xl,
              ),
            ],
          ),
        )
      ],
    );

    Widget _mobileOtherServicesTabView = Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: mobileLeftRightPadding,
              bottom: mobileLeftRightPadding),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FieldLayout(
                  caption:
                      "Choose the Other Service",
                  child: PrimaryDropdownButton<
                          ServiceModel>(
                      itemList:
                          _otherServicesDropdown,
                      value: otherServicesModel,
                      hint: "Select",
                      onChanged: (value) {
                        if (value?.service_id ==
                            -1) {
                          addNewServiceDialog(
                              context: context,
                              onAdd:
                                  (serviceName) {
                                Navigator.of(
                                        context)
                                    .pop();
                                setState(() {
                                  _choosen_services.add(ChoosenServiceModel(
                                      no: _choosen_services
                                              .length +
                                          1,
                                      name:
                                          serviceName,
                                      isNewRequestedServices:
                                          true,
                                      serviceType:
                                          'OTHER_SERVICE'));

                                  _choosen_other_services.add(ChoosenServiceModel(
                                      no: _choosen_services
                                              .length +
                                          1,
                                      name:
                                          serviceName,
                                      isNewRequestedServices:
                                          true,
                                      serviceType:
                                          'OTHER_SERVICE'));
                                });
                              });
                        } else {
                          setState(() {
                            _otherServicesDropdownCurrentValue =
                                ChoosenServiceModel(
                                    no: value!
                                        .service_id,
                                    name: value
                                        .service_name!
                                        .en,
                                    isNewRequestedServices:
                                        true,
                                    serviceType:
                                        'OTHER_SERVICE_DROPDOWN');
                          });
                        }
                      }),
                ),
              ),
              mobileHorizontalSizedBox,
              SizedBox(
                width: 70,
                child: PrimaryButton(
                  onTap: () {
                    if (_choosen_services
                        .isNotEmpty) {
                      bool exists = false;

                      _choosen_services
                          .forEach((element) {
                        if (element.name ==
                            _otherServicesDropdownCurrentValue
                                ?.name) {
                          exists = true;
                          final errorSnackBar =
                              CustomSnackBar
                                  .errorSnackBar(
                                      "This service is already added.");
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                                  errorSnackBar)
                              .closed
                              .then((value) =>
                                  ScaffoldMessenger.of(
                                          context)
                                      .clearSnackBars());
                        }
                      });
                      if (_otherServicesDropdownCurrentValue !=
                              null &&
                          !exists) {
                        setState(() {
                          _choosen_services.add(
                              _otherServicesDropdownCurrentValue!);
                          _choosen_other_services.add(
                              _otherServicesDropdownCurrentValue!);
                        });
                      }
                    } else {
                      if (_otherServicesDropdownCurrentValue !=
                          null) {
                        setState(() {
                          _choosen_services.add(
                              _otherServicesDropdownCurrentValue!);
                          _choosen_other_services.add(
                              _otherServicesDropdownCurrentValue!);
                        });
                      }
                    }
                    // context.vRouter.to(AddServiceDialogPath);
                  },
                  text: 'Add',
                ),
              )
            ],
          ),
        ),
        mobileVerticalSizedBox,
        Container(
          decoration: BoxDecoration(
            color: kPlainWhite,
            borderRadius:
                BorderRadius.circular(2),
          ),
          padding: EdgeInsets.all(
              mobileLeftRightPadding),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: mobileLeftRightPadding,
                    right:
                        mobileLeftRightPadding),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      child: Text('No.',
                          style: TextStyles.h4,
                          textAlign:
                              TextAlign.left),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          'Service',
                          style: TextStyles.h4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              mobileVerticalSizedBox,
              Container(
                height: hp(24),
                color: kBackgroundColor,
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          _choosen_other_services
                              .length,
                      itemBuilder:
                          (BuildContext ctx,
                              int i) {
                        if (_choosen_other_services[
                                        i]
                                    .serviceType ==
                                'OTHER_SERVICE_DROPDOWN' ||
                            _choosen_other_services[
                                        i]
                                    .serviceType ==
                                'OTHER_SERVICE') {
                          return _mobileChoosenServices(
                              _choosen_other_services[
                                  i],
                              i);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
              SizedBox(
                height: Insets.xl,
              ),
            ],
          ),
        )
      ],
    );

    Widget _mobileFormFirst = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                mobileLeftFormStatusDisplay(
                    context, 0),
                mobileHorizontalSizedBox,
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: kBlackVariant
                          .withOpacity(0.1),
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(
                      mobileLeftRightPadding),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Basic Information',
                              textAlign: TextAlign
                                  .center,
                              style:
                                  MS.lableBlack),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              singleBlock(
                                text:
                                    "First Name",
                                width: 240,
                                child:
                                    PrimaryTextField(
                                        enabled:
                                            false,
                                        controller:
                                            _firstNameField,
                                        text:
                                            "John",
                                        onChanged:
                                            (firstName) {
                                          // _firstNameField.text = firstName;
                                        }),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              singleBlock(
                                text: "Last Name",
                                width: 240,
                                child:
                                    PrimaryTextField(
                                        enabled:
                                            false,
                                        text:
                                            "Williamson",
                                        controller:
                                            _lastNameField,
                                        onChanged:
                                            (lastName) {
                                          // _lastNameField.text = lastName;
                                        }),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              singleBlock(
                                text: "Email ID",
                                width: 240,
                                child: PrimaryTextField(
                                    enabled:
                                        false,
                                    text:
                                        "joe@example.com",
                                    controller:
                                        _emailField,
                                    onChanged:
                                        (firstName) {}),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              singleBlock(
                                text:
                                    "Mobile No.",
                                width: 240,
                                child: PrimaryTextField(
                                    enabled:
                                        false,
                                    text:
                                        "54545455",
                                    controller:
                                        _mobileField,
                                    onChanged:
                                        (firstName) {}),
                              ),
                            ],
                          ),
                        ],
                      ),
                      mobileVerticalSizedBox,
                      _mobileformButtons
                    ],
                  ),
                ))
              ],
            ),
          ),
        ]);

    Widget _mobileFormTwo = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                mobileLeftFormStatusDisplay(
                    context, 1),
                mobileHorizontalSizedBox,
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(
                      mobileLeftRightPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: kBlackVariant
                          .withOpacity(0.1),
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                              'Company Information',
                              textAlign: TextAlign
                                  .center,
                              style:
                                  MS.lableBlack),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              singleBlock(
                                text:
                                    "Company Name",
                                width: 240,
                                child: PrimaryTextField(
                                    controller:
                                        _companyInfo,
                                    text: "",
                                    onChanged:
                                        (name) {}),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 240,
                                child:
                                    FieldLayout(
                                  caption:
                                      "Type Of Organisation",
                                  child: PrimaryDropdownButton<
                                          OrganisationTypesModel>(
                                      itemList:
                                          _typeOfOrganizationDropdown,
                                      hint:
                                          'Select',
                                      value: null,
                                      isExpand:
                                          true,
                                      onChanged:
                                          (value) {
                                        setState(
                                            () {
                                          organisationTypesModel =
                                              value;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Expanded(
                                child:
                                    singleBlock(
                                  width: 240,
                                  height: 100,
                                  text:
                                      "Registered Office Address",
                                  child: PrimaryTextField(
                                      controller:
                                          _registredOfficeAddress,
                                      text: "",
                                      minLines: 3,
                                      maxLines: 5,
                                      keyboardType:
                                          TextInputType
                                              .multiline,
                                      onChanged:
                                          (add) {}),
                                ),
                              ),
                            ],
                          ),
                          mobileVerticalSizedBox,
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .start,
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children: [
                                SizedBox(
                                  width: 240,
                                  child: MultiSelectDialogField<
                                      EmirateModel?>(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                kSupportBlue),
                                        borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(4))),
                                    buttonIcon: Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        color:
                                            kSupportBlue),
                                    items:
                                        _multiSelect,
                                    listType:
                                        MultiSelectListType
                                            .LIST,
                                    searchable:
                                        true,
                                    initialValue:
                                        null,
                                    searchIcon: Icon(
                                        Icons
                                            .search,
                                        color:
                                            kSupportBlue),
                                    buttonText: Text(
                                        "Select Emirates",
                                        style: TextStyles
                                            .body16
                                            .copyWith(
                                                color: kDarkGrey)),
                                    selectedColor:
                                        kSupportBlue,
                                    selectedItemsTextStyle:
                                        TextStyle(
                                            color:
                                                kSupportBlue),
                                    onConfirm:
                                        (list) {
                                      setState(
                                          () {
                                        emirateList =
                                            list;
                                      });
                                    },
                                  ),
                                )
                              ]),
                        ],
                      ),
                      mobileVerticalSizedBox,
                      _mobileformButtons
                    ],
                  ),
                ))
              ],
            ),
          ),
        ]);

    Widget _mobileFormThree = SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                mobileLeftFormStatusDisplay(
                    context, 2),
                mobileHorizontalSizedBox,
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(
                      mobileLeftRightPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: kBlackVariant
                          .withOpacity(0.1),
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(
                                  mobileLeftRightPadding),
                              child: Text(
                                  'Choose the service',
                                  textAlign:
                                      TextAlign
                                          .center,
                                  style: MS
                                      .miniestHeaderBlack)),
                          Container(
                              height: hp(57.4),
                              decoration:
                                  BoxDecoration(
                                color:
                                    kPlainWhite,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            12),
                              ),
                              child: Column(
                                children: [
                                  TabBar(
                                    controller:
                                        _tabController,
                                    tabs: [
                                      Text(
                                        'Facility\nManagement',
                                        style: MS
                                            .miniestHeaderBlack,
                                      ),
                                      Text(
                                        'Other\nServices',
                                        style: MS
                                            .miniestHeaderBlack,
                                      )
                                    ],
                                    indicatorColor:
                                        kSupportBlue,
                                    labelColor:
                                        Colors
                                            .black,
                                    unselectedLabelColor:
                                        kBlackVariant,
                                    labelStyle: TextStyles
                                        .h4
                                        .copyWith(
                                            color:
                                                kBlackVariant),
                                    indicatorWeight:
                                        3,
                                    labelPadding:
                                        EdgeInsets
                                            .all(
                                                mobileLeftRightPadding),
                                  ),
                                  Expanded(
                                    child:
                                        Container(
                                      width: double
                                          .infinity,
                                      child:
                                          TabBarView(
                                        controller:
                                            _tabController,
                                        children: [
                                          _mobileFacilityManagementTabView,
                                          _mobileOtherServicesTabView
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      mobileVerticalSizedBox,
                      _mobileformButtons,
                      mobileVerticalSizedBox,
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );

    Widget _mobileContent() {
      return SingleChildScrollView(
          child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
            // mobileStackBannerImage(
            //     imageLocation: 'assets/service/services-banner.jpg',
            //     header: 'Service Provider ',
            //     subHeader: 'Offer Services to Property Owners With Eases'),
            mobileVerticalSizedBox,
            BlocListener<ServiceProviderCubit,
                ServiceProviderState>(
              bloc: _cubit,
              listener: (_, state) {
                if (state is LServiceListForFacility ||
                    state
                        is LServiceListForOther ||
                    state is LOrganisationTypes ||
                    state is LEmirateList) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state
                        is FServiceListForFacility ||
                    state
                        is FServiceListForOther ||
                    state is FOrganisationTypes ||
                    state is FEmirateList) {
                  // Handle
                  SnackBar snackBar =
                      CustomSnackBar.errorSnackBar(
                          "Unexpected failure occured at login. Please try again after sometime.");

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                } else if (state
                    is SOrganisationTypes) {
                  setState(() {
                    isLoading = false;
                    _typeOfOrganizationDropdown
                        .addAll(
                            state.result.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      );
                    }));
                  });
                } else if (state
                    is SServiceListForFacility) {
                  setState(() {
                    isLoading = false;
                    _facilityServicesDropdown
                        .addAll(
                            state.result.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                            e.service_name!.en),
                      );
                    }));
                  });
                } else if (state
                    is SServiceListForOther) {
                  setState(() {
                    isLoading = false;
                    _otherServicesDropdown.addAll(
                        state.result.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                            e.service_name!.en),
                      );
                    }));
                  });
                } else if (state
                    is SEmirateList) {
                  setState(() {
                    isLoading = false;

                    _multiSelect.addAll(
                        state.result.map((e) {
                      return MultiSelectItem<
                          EmirateModel>(
                        e,
                        e.emirate_name == ""
                            ? "n/a"
                            : e.emirate_name
                                .toString(),
                      );
                    }));
                  });
                } else if (state is LAddService) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is FAddService) {
                  SnackBar snackBar =
                      CustomSnackBar
                          .errorSnackBar(state
                              .failure
                              .errorMessage);

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                } else if (state is SAddService) {
                  setState(() {
                    isLoading = false;
                  });
                  serviceProviderSuccessDialog(
                      context);
                  // context.vRouter.to(AddServiceSuccessDialogPath);
                }
              },
              child: isLoading
                  ? Column(
                      children: [
                        SizedBox(
                            height: hp(60.4),
                            child: Center(
                                child: SpinKitThreeBounce(
                                    color:
                                        kSupportBlue))),
                        SizedBox(
                          height:
                              Insets.oldOffset,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        mobileHeader(),
                        mobileVerticalSizedBox,
                        if (_formIndex == 0)
                          _mobileFormFirst,
                        if (_formIndex == 1)
                          _mobileFormTwo,
                        if (_formIndex == 2)
                          _mobileFormThree,
                      ],
                    ),
            ),
          ]));
    }

    return BlocProvider(
      create: (_) => _cubit,
      child: Responsive.isMobile(context)
          ? SafeArea(
              child: SliverScaffold(
                  title: 'Service Providers',
                  imageLocation:
                      'assets/service/services-banner.jpg',
                  isSearch: false,
                  child: Container(
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(context)
                                .size
                                .height,
                        maxWidth:
                            MediaQuery.of(context)
                                .size
                                .width,
                      ),
                      color: kBackgroundColor,
                      child: _mobileContent())))
          : Scaffold(
              backgroundColor: kBackgroundColor,
              appBar:
                  Responsive.isDesktop(context)
                      ? ToolBar()
                      : null,
              body: ListView(
                shrinkWrap: true,
                children: [
                  FormComponents.stackBannerImage(
                      context),
                  SizedBox(
                    height: Insets.oldOffset,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Responsive.isDesktop(
                              context)
                          ? Insets.toolBarSize
                          : Insets.med,
                      right: Responsive.isDesktop(
                              context)
                          ? Insets.toolBarSize
                          : Insets.med,
                    ),
                    child: BlocListener<
                        ServiceProviderCubit,
                        ServiceProviderState>(
                      bloc: _cubit,
                      listener: (_, state) {
                        if (state is LServiceListForFacility ||
                            state
                                is LServiceListForOther ||
                            state
                                is LOrganisationTypes ||
                            state
                                is LEmirateList) {
                          setState(() {
                            isLoading = true;
                          });
                        } else if (state
                                is FServiceListForFacility ||
                            state
                                is FServiceListForOther ||
                            state
                                is FOrganisationTypes ||
                            state
                                is FEmirateList) {
                          // Handle
                          SnackBar snackBar =
                              CustomSnackBar
                                  .errorSnackBar(
                                      "Unexpected failure occured at login. Please try again after sometime.");

                          ScaffoldMessenger.of(
                              context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                                snackBar);
                        } else if (state
                            is SOrganisationTypes) {
                          setState(() {
                            isLoading = false;
                            _typeOfOrganizationDropdown
                                .addAll(state
                                    .result
                                    .map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child:
                                    Text(e.name),
                              );
                            }));
                          });
                        } else if (state
                            is SServiceListForFacility) {
                          setState(() {
                            isLoading = false;

                            _tempFacilityServicesDropdown
                                .addAll(state
                                    .result
                                    .map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e
                                    .service_name!
                                    .en),
                              );
                            }));
                            _facilityServicesDropdown
                                .addAll(state
                                    .result
                                    .map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e
                                    .service_name!
                                    .en),
                              );
                            }));
                          });
                        } else if (state
                            is SServiceListForOther) {
                          setState(() {
                            isLoading = false;
                            _otherServicesDropdown
                                .addAll(state
                                    .result
                                    .map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e
                                    .service_name!
                                    .en),
                              );
                            }));
                          });
                        } else if (state
                            is SEmirateList) {
                          setState(() {
                            isLoading = false;
                            _multiSelect.addAll(
                                state.result
                                    .map((e) {
                              return MultiSelectItem<
                                  EmirateModel>(
                                e,
                                e.emirate_name ==
                                        ""
                                    ? "n/a"
                                    : e.emirate_name
                                        .toString(),
                              );
                            }));
                          });
                        } else if (state
                            is LAddService) {
                          setState(() {
                            isLoading = true;
                          });
                        } else if (state
                            is FAddService) {
                          SnackBar snackBar =
                              CustomSnackBar
                                  .errorSnackBar(state
                                      .failure
                                      .errorMessage);

                          ScaffoldMessenger.of(
                              context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                                snackBar);
                        } else if (state
                            is SAddService) {
                          setState(() {
                            isLoading = false;
                          });
                          serviceProviderSuccessDialog(
                              context);
                          // context.vRouter.to(
                          //     AddServiceSuccessDialogPath);
                        }
                      },
                      child: isLoading
                          ? Column(
                              children: [
                                SizedBox(
                                    height:
                                        hp(60.4),
                                    child: Center(
                                        child: SpinKitThreeBounce(
                                            color:
                                                kSupportBlue))),
                                SizedBox(
                                  height: Insets
                                      .oldOffset,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                FormComponents
                                    .header(),
                                SizedBox(
                                  height: Insets
                                      .oldOffset,
                                ),
                                if (_formIndex ==
                                    0)
                                  _formFirst,
                                if (_formIndex ==
                                    1)
                                  _formTwo,
                                if (_formIndex ==
                                    2)
                                  _formThree,
                                SizedBox(
                                  height: Insets
                                      .oldOffset,
                                ),
                                // FormComponents.adBanner(context),
                                SizedBox(
                                  height: Insets
                                      .oldOffset,
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (Responsive.isDesktop(
                      context))
                    Footer(),
                ],
              ),
            ),
    );
  }
}
