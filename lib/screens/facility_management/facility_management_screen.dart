import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/scaffold/sliver_scaffold.dart';
import 'package:real_estate_portal/screens/property_owners/components/mobile_body.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/buttons/primary_outlined_button.dart';
import '../../components/footer.dart';
import '../../components/input_fields/primary_dropdown_button.dart';
import '../../components/input_fields/primary_text_field.dart';
import '../../components/mobile_app_bar.dart';
import '../../components/snack_bar/custom_snack_bar.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/facility_management_model/property_location_model.dart';
import '../../routes/routes.dart';
import '../service_providers/components/banner_image.dart';
import 'cubit/basic_info_facility_mng_cubit.dart';
import 'facility_management_success_screen.dart';

BasicInfoFacilityMngCubit _cubit = sl<BasicInfoFacilityMngCubit>();

class FacilityManagementScreen extends StatelessWidget {
  const FacilityManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: FacilityManagementView(),
    );
  }
}

class FacilityManagementView extends StatefulWidget {
  const FacilityManagementView({Key? key}) : super(key: key);

  @override
  State<FacilityManagementView> createState() => _FacilityManagementViewState();
}

class _FacilityManagementViewState extends State<FacilityManagementView> {
  late TextEditingController _companyNameController;

  TextEditingController _firstNameField = TextEditingController();
  TextEditingController _lastNameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _mobileField = TextEditingController();

  StepState _basicInfoStepState = StepState.editing;
  StepState _companyInfoStepState = StepState.indexed;
  StepState _propertyInfoStepState = StepState.indexed;
  StepState _amcStepState = StepState.indexed;

  int _index = 0;

  bool _isRentListingType = false;
  bool _isSaleListingType = false;

  bool _interestedInVillasAmc = false;
  bool _interestedInAppartmentsAmc = false;
  bool _interestedInBuildingsAmc = false;

  bool _isFree = false;
  bool _isBasic = false;
  bool _isStandard = false;
  bool _isPremium = false;

  String? _typeOfOrganization;

  bool _enableCompanyName = false;
  bool _readOnlyCompanyName = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _companyNameController = TextEditingController();

    _cubit.initBasicInfoForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    print('#log amc : ${context.vRouter.queryParameters}');
    if (!context.vRouter.queryParameters.keys.contains("amcType")) {
    } else {
      String type = context.vRouter.queryParameters["amcType"] as String;

      if (type == 'free') {
        _isFree = true;
      } else if (type == 'basic') {
        _isBasic = true;
      } else if (type == 'standard') {
        _isStandard = true;
      } else if (type == 'premium') {
        _isPremium = true;
      }

      context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
          isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
    }
  }

  void loadUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Redirect to Login
      debugPrint('#log : User not logged in');
    } else {
      String? _displayName = FirebaseAuth.instance.currentUser?.displayName;
      debugPrint('#log : User logged in as $_displayName');

      String? _emailName = FirebaseAuth.instance.currentUser?.email;
      String? _mobileNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
      _firstNameField.text = _displayName?.split(',').first ?? "";
      _lastNameField.text = _displayName?.split(',').last ?? "";
      _emailField.text = _emailName ?? "";
      _mobileField.text = _mobileNumber ?? "";
      context.read<BasicInfoFacilityMngCubit>().onFirstNameChanged(_firstNameField.text);
      context.read<BasicInfoFacilityMngCubit>().onLastNameChanged(_lastNameField.text);
      context.read<BasicInfoFacilityMngCubit>().onEmailChanged(_emailField.text);
      context.read<BasicInfoFacilityMngCubit>().phoneNumberChanged(_mobileField.text);
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);
    final _vSpace = SizedBox(
      height: Insets.xl,
    );
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    // * BASIC INFORMATION FORM
    Widget _basicInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            runSpacing: 20,
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              _singleBlock(
                text: "First Name",
                width: 280,
                child: PrimaryTextField(
                    text: "First Name", enabled: false, controller: _firstNameField, onChanged: (firstName) {}),
              ),
              _singleBlock(
                text: "Last Name",
                width: 280,
                child: PrimaryTextField(
                  text: "Last Name",
                  enabled: false,
                  controller: _lastNameField,
                ),
              ),
              _singleBlock(
                width: 280,
                text: "Email ID",
                child: PrimaryTextField(
                  text: "Email ID",
                  enabled: false,
                  controller: _emailField,
                ),
              ),
              _singleBlock(
                  width: 280,
                  text: "Mobile No.",
                  child: PrimaryTextField(
                      enabled: false, controller: _mobileField, text: "+919845454525", onChanged: (firstName) {})),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );

    // * COMPANY INFORMATION FORM
    Widget _companyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _singleBlock(
                text: "Type of Organisation",
                child: PrimaryDropdownButton<String>(
                  hint: "Type of Organisation",
                  itemList: [
                    DropdownMenuItem(child: Text("Agency", style: TextStyles.body16), value: "agency"),
                    DropdownMenuItem(
                        child: Text("Single private owner", style: TextStyles.body16), value: "single_owner")
                  ],
                  value: _typeOfOrganization,
                  onChanged: (String? value) {
                    _typeOfOrganization = value;
                    if (value != null && value.contains('single_owner')) {
                      _companyNameController.clear();
                      _enableCompanyName = false;
                      _readOnlyCompanyName = true;
                    } else {
                      _enableCompanyName = true;
                      _readOnlyCompanyName = false;
                    }
                    setState(() {});
                    context.read<BasicInfoFacilityMngCubit>().typeOfOrganizationSelected(value ?? "");
                  },
                ),
                width: 400,
              ),
              _enableCompanyName
                  ? _singleBlock(
                      width: 400,
                      text: "Company Name",
                      child: PrimaryTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
                        ],
                        controller: _companyNameController,
                        enabled: _enableCompanyName,
                        readOnly: _readOnlyCompanyName,
                        text: "company name",
                        onChanged: (companyName) =>
                            context.read<BasicInfoFacilityMngCubit>().companyNameChanged(companyName),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: 20)
      ],
    );

    // * PROPERTY INFO Form
    Widget _propertyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          runSpacing: 20,
          spacing: 20,
          children: [
            _singleBlock(
              text: "No. of Properties",
              child: PrimaryTextField(
                  text: "No. of Properties",
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                  ],
                  onChanged: (numberOfProperties) =>
                      context.read<BasicInfoFacilityMngCubit>().numberofPropertiesChanged(numberOfProperties)),
            ),
            BlocBuilder<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
              buildWhen: (previous, current) =>
                  previous.propertyLocationModel.list != current.propertyLocationModel.list,
              builder: (context, state) {
                return MultiSelectDialogField<PropertyLocationModel?>(
                  decoration: BoxDecoration(
                      border: Border.all(color: kSupportBlue), borderRadius: BorderRadius.all(Radius.circular(4))),
                  buttonIcon: Icon(Icons.keyboard_arrow_down, color: kSupportBlue),
                  items: state.propertyLocationModel.isNotEmpty
                      ? state.propertyLocationModel.list.map((e) => MultiSelectItem(e, e.name)).toList()
                      : [],
                  listType: MultiSelectListType.LIST,
                  searchable: true,
                  initialValue: state.selectedLocations,
                  searchIcon: Icon(Icons.search, color: kSupportBlue),
                  buttonText: Text("Select location", style: TextStyles.body16.copyWith(color: kDarkGrey)),
                  selectedColor: kSupportBlue,
                  onConfirm: (propertyLocations) =>
                      context.read<BasicInfoFacilityMngCubit>().selectPropertyLocation(propertyLocations),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Listing Type", style: TextStyles.body14.copyWith(color: kLightBlue)),
                SizedBox(height: 10),
                CheckboxListTile(
                  value: _isRentListingType,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() => _isRentListingType = value!);
                    context
                        .read<BasicInfoFacilityMngCubit>()
                        .selectListingTypeRentChanged(_isRentListingType, _isSaleListingType);
                  },
                  title: Text("Rent", style: TextStyles.body16),
                ),
                CheckboxListTile(
                  value: _isSaleListingType,
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  onChanged: (value) {
                    setState(() => _isSaleListingType = value!);
                    context
                        .read<BasicInfoFacilityMngCubit>()
                        .selectListingTypeRentChanged(_isRentListingType, _isSaleListingType);
                  },
                  title: Text("Sale", style: TextStyles.body16),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20)
      ],
    );

    // * AMC PACKAGES
    Widget _amcPackages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("I am interested to know more about the following package.",
            style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 10),
        CheckboxListTile(
          value: _isFree,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {
            setState(() => _isFree = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Free", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isBasic,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isBasic = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Basic", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isStandard,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isStandard = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Standard", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isPremium,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isPremium = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Premium", style: TextStyles.body16),
        ),
      ],
    );

    Widget stepper = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
        borderRadius: Corners.xlBorder,
      ),
      child: Stepper(
        currentStep: _index,
        physics: NeverScrollableScrollPhysics(),
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          return Row(
            children: <Widget>[
              Spacer(),
              if (_index > 0)
                PrimaryOutlinedButton(
                  onTap: controlsDetails.onStepCancel!,
                  text: 'Previous',
                  width: null,
                  height: null,
                ),
              SizedBox(width: 30.0.w),
              BlocBuilder<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
                builder: (context, state) {
                  if (_index == 0) {
                    return PrimaryElevatedButton(
                      onTap: controlsDetails.onStepContinue!,
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: false,
                    );
                  } else if (_index == 1) {
                    return PrimaryElevatedButton(
                      onTap: controlsDetails.onStepContinue!,
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: _enableCompanyName ? !state.companyFormStatus.isValid : false,
                    );
                  } else if (_index == 2) {
                    return PrimaryElevatedButton(
                      onTap: controlsDetails.onStepContinue!,
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: !state.propertyFormStatus.isValid,
                    );
                  } else if (_index == 3) {
                    return PrimaryElevatedButton(
                      onTap: () => context.read<BasicInfoFacilityMngCubit>().submitForm(),
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: !state.amcFormStatus.isValid ||
                          !state.companyFormStatus.isValid ||
                          !state.propertyFormStatus.isValid,
                      isLoading: state.status.isSubmissionInProgress,
                    );
                  } else {
                    return PrimaryButton(
                      onTap: controlsDetails.onStepContinue!,
                      text: 'Next',
                      width: null,
                      height: null,
                    );
                  }
                },
              ),
            ],
          );
        },
        onStepTapped: (index) {
          setState(() {
            _index = index;
          });
        },
        onStepContinue: () {
          if (_index <= 3) {
            setState(() => _index += 1);
          }
        },
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Basic Information', style: TextStyles.h2.copyWith(color: kSupportBlue)),
            content: _basicInfo,
            state: _basicInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Company Information', style: TextStyles.h2.copyWith(color: kSupportBlue)),
            content: _companyInfo,
            state: _companyInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Property Information', style: TextStyles.h2.copyWith(color: kSupportBlue)),
            content: _propertyInfo,
            state: _propertyInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Property Owners Packages', style: TextStyles.h2.copyWith(color: kSupportBlue)),
            content: _amcPackages,
            state: _amcStepState,
            isActive: true,
          ),
        ],
      ),
    );

    Widget stack = Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [
                  BannerImage(
                    imageLocation: 'assets/app/banner-property-listing.png',
                  )
                ]
              : [],
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Facility Management Service Providers", style: TS.headerWhite),
              _vSpace,
              SizedBox(
                width: wp(40),
                child: Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TS.bodyWhite,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );

// ************************************** Mobile Widgets **************************************
    Widget _mobileBasicInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            runSpacing: 20,
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              _singleBlock(
                text: "First Name",
                width: 280,
                child: PrimaryTextField(
                    text: "First Name", enabled: false, controller: _firstNameField, onChanged: (firstName) {}),
              ),
              _singleBlock(
                text: "Last Name",
                width: 280,
                child: PrimaryTextField(
                  text: "Last Name",
                  enabled: false,
                  controller: _lastNameField,
                ),
              ),
              _singleBlock(
                width: 280,
                text: "Email ID",
                child: PrimaryTextField(
                  text: "Email ID",
                  enabled: false,
                  controller: _emailField,
                ),
              ),
              _singleBlock(
                width: 280,
                text: "Mobile No.",
                child: PrimaryTextField(
                    enabled: false, controller: _mobileField, text: "+919845454525", onChanged: (firstName) {}),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );

    // * COMPANY INFORMATION FORM
    Widget _mobileCompanyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _singleBlock(
                text: "Type of Organisation",
                child: PrimaryDropdownButton<String>(
                  hint: "Type of Organisation",
                  itemList: [
                    DropdownMenuItem(child: Text("Agency", style: TextStyles.body16), value: "agency"),
                    DropdownMenuItem(
                        child: Text("Single private owner", style: TextStyles.body16), value: "single_owner")
                  ],
                  value: _typeOfOrganization,
                  onChanged: (String? value) {
                    _typeOfOrganization = value;
                    if (value != null && value.contains('single_owner')) {
                      _companyNameController.clear();
                      _enableCompanyName = false;
                      _readOnlyCompanyName = true;
                    } else {
                      _enableCompanyName = true;
                      _readOnlyCompanyName = false;
                    }
                    setState(() {});
                    context.read<BasicInfoFacilityMngCubit>().typeOfOrganizationSelected(value ?? "");
                  },
                ),
                width: 400,
              ),
              _enableCompanyName
                  ? _singleBlock(
                      width: 400,
                      text: "Company Name",
                      child: PrimaryTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
                        ],
                        controller: _companyNameController,
                        enabled: _enableCompanyName,
                        readOnly: _readOnlyCompanyName,
                        text: "company name",
                        onChanged: (companyName) =>
                            context.read<BasicInfoFacilityMngCubit>().companyNameChanged(companyName),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(height: 20)
      ],
    );

    // * PROPERTY INFO FORM
    Widget _mobilePropertyInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          runSpacing: 20,
          spacing: 20,
          children: [
            _singleBlock(
              text: "No. of Properties",
              child: PrimaryTextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                  ],
                  text: "No. of Properties",
                  onChanged: (numberOfProperties) =>
                      context.read<BasicInfoFacilityMngCubit>().numberofPropertiesChanged(numberOfProperties)),
            ),
            BlocBuilder<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
              buildWhen: (previous, current) =>
                  previous.propertyLocationModel.list != current.propertyLocationModel.list,
              builder: (context, state) {
                return MultiSelectDialogField<PropertyLocationModel?>(
                  decoration: BoxDecoration(
                      border: Border.all(color: kSupportBlue), borderRadius: BorderRadius.all(Radius.circular(4))),
                  buttonIcon: Icon(Icons.keyboard_arrow_down, color: kSupportBlue),
                  items: state.propertyLocationModel.isNotEmpty
                      ? state.propertyLocationModel.list.map((e) => MultiSelectItem(e, e.name)).toList()
                      : [],
                  listType: MultiSelectListType.LIST,
                  searchable: true,
                  initialValue: state.selectedLocations,
                  searchIcon: Icon(Icons.search, color: kSupportBlue),
                  buttonText: Text("Select location", style: TextStyles.body16.copyWith(color: kDarkGrey)),
                  selectedColor: kSupportBlue,
                  onConfirm: (propertyLocations) =>
                      context.read<BasicInfoFacilityMngCubit>().selectPropertyLocation(propertyLocations),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Listing Type", style: TextStyles.body14.copyWith(color: kLightBlue)),
                SizedBox(height: 10),
                CheckboxListTile(
                  value: _isRentListingType,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() => _isRentListingType = value!);
                    context
                        .read<BasicInfoFacilityMngCubit>()
                        .selectListingTypeRentChanged(_isRentListingType, _isSaleListingType);
                  },
                  title: Text("Rent", style: TextStyles.body16),
                ),
                CheckboxListTile(
                  value: _isSaleListingType,
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  onChanged: (value) {
                    setState(() => _isSaleListingType = value!);
                    context
                        .read<BasicInfoFacilityMngCubit>()
                        .selectListingTypeRentChanged(_isRentListingType, _isSaleListingType);
                  },
                  title: Text("Sale", style: TextStyles.body16),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20)
      ],
    );

    // * AMC PACKAGES
    Widget _mobileAmcPackages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("I am interested to know more about the following package.",
            style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 10),
        CheckboxListTile(
          value: _isFree,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {
            setState(() => _isFree = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Free", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isBasic,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isBasic = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Basic", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isStandard,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isStandard = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Standard", style: TextStyles.body16),
        ),
        CheckboxListTile(
          value: _isPremium,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          onChanged: (value) {
            setState(() => _isPremium = value!);
            context.read<BasicInfoFacilityMngCubit>().annualMaintainenceContractChanged(
                isFree: _isFree, isBasic: _isBasic, isStandard: _isStandard, isPremium: _isPremium);
          },
          title: Text("Premium", style: TextStyles.body16),
        ),
      ],
    );

    Widget _mobileStepper = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
        borderRadius: Corners.xlBorder,
      ),
      margin: EdgeInsets.all(mobileLeftRightPadding),
      child: Stepper(
        currentStep: _index,
        physics: NeverScrollableScrollPhysics(),
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          return Row(
            children: <Widget>[
              Spacer(),
              if (_index > 0)
                PrimaryOutlinedButton(
                  onTap: controlsDetails.onStepCancel!,
                  text: 'Previous',
                  width: null,
                  height: null,
                ),
              SizedBox(width: 30.0.w),
              BlocBuilder<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
                builder: (context, state) {
                  if (_index == 0) {
                    return PrimaryElevatedButton(
                      onTap: () {
                        controlsDetails.onStepContinue!();
                      },
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: false,
                    );
                  } else if (_index == 1) {
                    return PrimaryElevatedButton(
                      onTap: () {
                        controlsDetails.onStepContinue!();
                      },
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: _enableCompanyName ? !state.companyFormStatus.isValid : false,
                    );
                  } else if (_index == 2) {
                    return PrimaryElevatedButton(
                      onTap: () {
                        controlsDetails.onStepContinue!();
                      },
                      text: 'Next',
                      width: null,
                      height: 38,
                      disabled: !state.propertyFormStatus.isValid,
                    );
                  } else if (_index == 3) {
                    return PrimaryElevatedButton(
                      width: null,
                      height: 38,
                      onTap: () {
                        context.read<BasicInfoFacilityMngCubit>().submitForm();
                      },
                      text: 'Next',
                      disabled: !state.amcFormStatus.isValid ||
                          !state.companyFormStatus.isValid ||
                          !state.propertyFormStatus.isValid,
                      isLoading: state.status.isSubmissionInProgress,
                    );
                  } else {
                    return PrimaryButton(
                      onTap: controlsDetails.onStepContinue!,
                      text: 'Next',
                      width: null,
                      height: null,
                    );
                  }
                },
              ),
            ],
          );
        },
        onStepTapped: (index) {
          setState(() {
            _index = index;
          });
        },
        onStepContinue: () {
          if (_index <= 3) {
            setState(() => _index += 1);
          }
        },
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Basic Information', style: MS.miniHeaderBlack),
            content: _mobileBasicInfo,
            state: _basicInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Company Information', style: MS.miniHeaderBlack),
            content: _mobileCompanyInfo,
            state: _companyInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Property Information', style: MS.miniHeaderBlack),
            content: _mobilePropertyInfo,
            state: _propertyInfoStepState,
            isActive: true,
          ),
          Step(
            title: Text('Property Owners Packages', style: MS.miniHeaderBlack),
            content: _mobileAmcPackages,
            state: _amcStepState,
            isActive: true,
          ),
        ],
      ),
    );

    _mobileContent() {
      return SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        mobileVerticalSizedBox,
        mobileHeader(),
        mobileVerticalSizedBox,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: BlocListener<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
                listener: (context, state) {
                  // update stepper state for basic Info
                  if (state.basicFormStatus.isValid) {
                    setState(() => _basicInfoStepState = StepState.complete);
                  } else if (state.basicFormStatus.isInvalid) {
                    setState(() => _basicInfoStepState = StepState.editing);
                  }

                  // update stepper state for company Info
                  if (state.companyFormStatus.isValid) {
                    setState(() => _companyInfoStepState = StepState.complete);
                  } else if (state.companyFormStatus.isInvalid) {
                    setState(() => _companyInfoStepState = StepState.editing);
                  }

                  // update stepper state for property Info
                  if (state.propertyFormStatus.isValid) {
                    setState(() => _propertyInfoStepState = StepState.complete);
                  } else if (state.propertyFormStatus.isInvalid) {
                    setState(() => _propertyInfoStepState = StepState.editing);
                  }

                  // update stepper state for amc
                  if (state.amcFormStatus.isValid) {
                    setState(() => _propertyInfoStepState = StepState.complete);
                  } else if (state.amcFormStatus.isInvalid) {
                    setState(() => _propertyInfoStepState = StepState.editing);
                  }

                  switch (state.status) {
                    case FormzStatus.submissionFailure:
                      SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failureMessage.isNotEmpty
                          ? state.failureMessage
                          : "Unexpected failure occured at login. Please try again after sometime.");

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                      break;
                    case FormzStatus.submissionSuccess:
                      facilityManagementSuccessScreen(context);
                      // context.vRouter.to(
                      //     FaciltyManagementSuccessScreenPath);
                      break;
                    default:
                      break;
                  }
                },
                child: _mobileStepper,
              ),
            ),
          ],
        ),
      ]));
    }

    return Responsive.isMobile(context)
        ? SafeArea(
            child: SliverScaffold(
                title: 'Property Owner Registration',
                imageLocation: 'assets/app/banner-property-listing.png',
                isSearch: false,
                child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    color: kBackgroundColor,
                    child: _mobileContent())))
        : Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: Responsive.isDesktop(context) ? ToolBar() : MobileAppBar(),
            body: ListView(
              shrinkWrap: true,
              children: [
                stack,
                SizedBox(
                  height: Insets.xxl,
                ),
                Center(child: Text("Let’s join hands!", style: TS.miniHeaderBlack)),
                SizedBox(
                  height: Insets.xxl,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 180.0.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: BlocListener<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
                          listener: (context, state) {
                            // update stepper state for basic Info
                            if (state.basicFormStatus.isValid) {
                              setState(() => _basicInfoStepState = StepState.complete);
                            } else if (state.basicFormStatus.isInvalid) {
                              setState(() => _basicInfoStepState = StepState.editing);
                            }

                            // update stepper state for company Info
                            if (state.companyFormStatus.isValid) {
                              setState(() => _companyInfoStepState = StepState.complete);
                            } else if (state.companyFormStatus.isInvalid) {
                              setState(() => _companyInfoStepState = StepState.editing);
                            }

                            // update stepper state for property Info
                            if (state.propertyFormStatus.isValid) {
                              setState(() => _propertyInfoStepState = StepState.complete);
                            } else if (state.propertyFormStatus.isInvalid) {
                              setState(() => _propertyInfoStepState = StepState.editing);
                            }

                            // update stepper state for amc
                            if (state.amcFormStatus.isValid) {
                              setState(() => _propertyInfoStepState = StepState.complete);
                            } else if (state.amcFormStatus.isInvalid) {
                              setState(() => _propertyInfoStepState = StepState.editing);
                            }

                            switch (state.status) {
                              case FormzStatus.submissionFailure:
                                SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failureMessage.isNotEmpty
                                    ? state.failureMessage
                                    : "Unexpected failure occured at login. Please try again after sometime.");

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                                break;
                              case FormzStatus.submissionSuccess:
                                facilityManagementSuccessScreen(context);
                                // context.vRouter.to(
                                //     FaciltyManagementSuccessScreenPath);
                                break;
                              default:
                                break;
                            }
                          },
                          child: stepper,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Insets.xxl,
                ),
                if (Responsive.isDesktop(context)) Footer()
              ],
            ),
          );
  }

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

  Column labelDropDown(
    String caption,
    int? selectedValue,
    List<DropdownMenuItem> itemList,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: TextStyles.body12.copyWith(
            color: Color(0xFF99C9E7),
          ),
        ),
        SizedBox(height: 4),
        PrimaryDropdownButton(
          value: selectedValue,
          itemList: itemList,
          hint: hint,
        ),
      ],
    );
  }
}

class _PhoneNumberField extends StatelessWidget {
  const _PhoneNumberField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicInfoFacilityMngCubit, BasicInfoFacilityMngState>(
      buildWhen: (previous, current) => previous.basicFormStatus != current.basicFormStatus,
      builder: (context, state) {
        return InternationalPhoneNumberInput(
          onInputChanged: (phone) => context
              .read<BasicInfoFacilityMngCubit>()
              .phoneNumberChanged("${phone.dialCode}${phone.parseNumber().replaceAll(" ", "")}"),
          onInputValidated: (value) => context.read<BasicInfoFacilityMngCubit>().phoneNumberValidate(value),
          countries: ['AE', 'IN'],
          spaceBetweenSelectorAndTextField: Insets.sm,
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          inputDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 2.5, color: kSupportBlue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 2, color: kLightBlue),
            ),
          ),
          selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.DROPDOWN),
          errorMessage: state.mobileValid ? 'invalid mobile number' : null,
        );
      },
    );
  }
}
