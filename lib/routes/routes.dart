import 'package:firebase_auth/firebase_auth.dart';
import 'package:vrouter/vrouter.dart';

import '../components/dialogs/add_service_dialog.dart';
import '../components/dialogs/decline_offer_dialog.dart';
import '../components/dialogs/payment_plans_dialog.dart';
import '../components/dialogs/place_offer_dialog.dart';
import '../components/dialogs/register_interest_dialog.dart';
import '../components/dialogs/service_provider_success_dialog.dart';
import '../screens/about/about_screen.dart';
import '../screens/community_detail/community_detail_screen.dart';
import '../screens/company_guidlines/company_guidline_screen.dart';
import '../screens/cover_page/cover_screen.dart';
import '../screens/facility_management/facility_management_screen.dart';
import '../screens/facility_management/facility_management_success_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/mobile_menu/mobile_menu.dart';
import '../screens/my_properties/my_properties_screen.dart';
import '../screens/my_services/my_services_screen.dart';
import '../screens/project_detail/components/available_time_slot_dialog.dart';
import '../screens/project_detail/components/booked_confirmation_dialog.dart';
import '../screens/project_detail/project_detail_screen.dart';
import '../screens/project_listing/project_filter_screen.dart';
import '../screens/project_listing/project_listing_screen.dart';
import '../screens/property_detail/property_detail_screen.dart';
import '../screens/property_listing/property_filter_screen.dart';
import '../screens/property_listing/property_listing_screen.dart';
import '../screens/property_owners/property_owner_screen.dart';
import '../screens/service_providers/service_provider_screen.dart';
import '../screens/service_providers/service_registration_screen.dart';
import '../screens/services/components/success_dialog.dart';
import '../screens/services/service_main_screen.dart';
import '../screens/signup/email_verification_screen.dart';
import '../screens/signup/signup_form_screen.dart';
import '../screens/signup/signup_screen.dart';

const String CoverPath = "/";

const String HomePath = "/home";
const String MenuPath = "/menu";

//* Authentication
const String LoginPath = "/login";
const String OTPScreenPath = "/otp";
const String SignupPath = "/signup";
const String SignupFormPath = "/signup-form";
const String EmailVerificationPath =
    "/email-verification";

//* Facility management
const String PropertyOwnerPath =
    "/property-owner";

const String FacilityManagementPath =
    "/facility-management";
const String FaciltyManagementSuccessScreenPath =
    "facility-management-success";

//* Property pages
const String PropertyListingScreenPath =
    "/property-list";
const String PropertyDetailScreenPath =
    "/property-detail";
const String MobilePropertyFilterPath = "/filter";

//* Project pages
const String ProjectListingScreenPath =
    "/project-list";
const String ProjectDetailScreenPath =
    "/project-detail";
const String ProjectFilterScreenPath =
    "/project-filter";

//* Service pages
const String ServiceProviderScreenPath =
    "/service-provider";
const String ServiceRegistrationScreenPath =
    "/service-reg-first";

//* Dialogs
const String AvailableTimeSlotDialogPath =
    "/available_time_slot";
const String BookedTimeSlotDialogPath =
    "/booked_time_slot";
const String DeclineOfferDialogPath =
    "/decline_dialog";
const String PlaceOfferDialogPath =
    "/place_offer_dialog";
const String AddServiceDialogPath =
    "/service_dialog";
const String AddServiceSuccessDialogPath =
    "/add-service-success-dialog";
const String RegisterInterestDialogPath =
    "/register-interest-dialog";
const String PaymentPlansDialogPath =
    "/payment-plans-dialog";

//* Community Guidelines

const String CommunityGuidlinePath =
    "/community-guidelines";
const String CommunityListingPath =
    "/community-listings";
const String CommunityDetailsPath =
    "/community-details";
//* About
const String AboutPath = "/about-us";

//* Services
const String ServiceMainScreenPath = "/services";
const String
    ServiceEnquirySubmitSuccessDialogPath =
    "/enquiry-submitted";
const String MyServicesScreenPath =
    "/my-services";

//* My Properties
const String MyPropertiesScreenPath =
    '/my-properties';

List<VRouteElement> routes = [
  VWidget(
      path: CoverPath, widget: CoverPageScreen()),
  // Home initial routes
  VWidget(
    path: HomePath,
    widget: HomeScreen(),
  ),
  VWidget(
      path: MenuPath, widget: MobileMenuScreen()),

  // Authentication route
  VWidget(path: LoginPath, widget: LoginScreen()),
  VWidget(
      path: SignupPath, widget: SignupScreen()),
  VWidget(
      path: SignupFormPath,
      widget: SignupFormScreen()),
  VWidget(
      path: EmailVerificationPath,
      widget: EmailVerificationScreen()),

  // Property Owners
  VWidget(
      path: PropertyOwnerPath,
      widget: PropertyOwnerScreen()),
  // Facility management protected route

  VGuard(
    beforeEnter: (vRedirector) async {
      if (FirebaseAuth.instance.currentUser ==
          null) {
        print(
            '#log route : ${vRedirector.newVRouterData!.queryParameters}');

        if (vRedirector.newVRouterData!
                .queryParameters['isLogin'] ==
            'true') {
          return vRedirector
              .to(LoginPath, queryParameters: {
            "redirect": FacilityManagementPath,
            "amcType": vRedirector.newVRouterData!
                    .queryParameters['amcType'] ??
                ''
          });
        } else {
          return vRedirector
              .to(SignupPath, queryParameters: {
            "redirect": FacilityManagementPath,
            "amcType": vRedirector.newVRouterData!
                    .queryParameters['amcType'] ??
                ''
          });
        }
      } else {
        return null;
      }
    },
    stackedRoutes: [
      // Facility management success
      VWidget(
        path: FacilityManagementPath,
        widget: FacilityManagementScreen(),
      ),
    ],
  ),

  // Property
  VWidget(
      path: PropertyListingScreenPath,
      widget: PropertyListingScreen()),
  VWidget(
      path: PropertyDetailScreenPath,
      widget: PropertyDetailScreen()),
  VWidget(
      path: MobilePropertyFilterPath,
      widget: PropertyFilterScreen()),

  // Project
  VWidget(
      path: ProjectListingScreenPath,
      widget: ProjectListingScreen()),
  VWidget(
      path: ProjectDetailScreenPath,
      widget: ProjectDetailScreen()),
  VWidget(
      path: ProjectFilterScreenPath,
      widget: ProjectFilterScreen()),

  // Services
  VWidget(
      path: ServiceProviderScreenPath,
      widget: ServiceProviderScreen()),

  VGuard(
    beforeEnter: (vRedirector) async {
      if (FirebaseAuth.instance.currentUser ==
          null) {
        if (vRedirector.newVRouterData!
                .queryParameters['isLogin'] ==
            'true') {
          return vRedirector.to(LoginPath,
              queryParameters: {
                "redirect":
                    ServiceRegistrationScreenPath
              });
        } else {
          return vRedirector.to(SignupPath,
              queryParameters: {
                "redirect":
                    ServiceRegistrationScreenPath
              });
        }
      } else {
        return null;
      }
    },
    stackedRoutes: [
      // Facility management success
      VWidget(
        path: ServiceRegistrationScreenPath,
        widget: ServiceRegistrationView(),
        stackedRoutes: [
          VWidget(
              path: ServiceProviderScreenPath,
              widget: ServiceProviderScreen())
        ],
      ),
      VWidget(
          path: MyServicesScreenPath,
          widget: MyServiceScreen()),
    ],
  ),

  VWidget(
      path: AddServiceDialogPath,
      widget: AddServiceDialog()),
  // VWidget(path: AddServiceSuccessDialogPath, widget: ServiceProviderSuccessDialog()),

  // Book a slot
  // VGuard(
  //   beforeEnter: (vRedirector) async {
  //     print('#log newVRouterData queryParameters: ${vRedirector.newVRouterData!.queryParameters}');

  //     if (FirebaseAuth.instance.currentUser == null) {
  //       return vRedirector.to(LoginPath, queryParameters: {
  //         "redirect": AvailableTimeSlotDialogPath,
  //         "property_id": vRedirector.newVRouterData!.queryParameters["property_id"]!
  //       });
  //     } else {
  //       return null;
  //     }
  //   },
  //   stackedRoutes: [
  //     // Property management success
  //     VWidget(
  //       path: AvailableTimeSlotDialogPath,
  //       widget: AvailableTimeSlotDialog(),
  //       stackedRoutes: [VWidget(path: PropertyListingScreenPath, widget: PropertyListingScreen())],
  //     ),
  //   ],
  // ),
  // VWidget(path: AvailableTimeSlotDialogPath, widget: AvailableTimeSlotDialog()),
  VWidget(
      path: BookedTimeSlotDialogPath,
      widget: BookedConfirmationDialog()),
  VWidget(
      path: PaymentPlansDialogPath,
      widget: PaymentPlansDialog()),

  // Dialog
  // VWidget(path: DeclineOfferDialogPath, widget: DeclineOfferDialog()),
  VWidget(
      path: PlaceOfferDialogPath,
      widget: AcceptOfferDialog()),
  VWidget(
      path: RegisterInterestDialogPath,
      widget: RegisterInterestDialog()),

  // About
  VWidget(path: AboutPath, widget: AboutScreen()),

  // Community Guidelines
  VWidget(
      path: CommunityGuidlinePath,
      widget: CommunityGuidlineScreen()),
  VWidget(
      path: CommunityDetailsPath,
      widget: CommunityDetailScreen()),

  // Services

  VWidget(
      path: ServiceMainScreenPath,
      widget: ServicesScreen()),
  VWidget(
      path: ServiceEnquirySubmitSuccessDialogPath,
      widget: EnquirySubmittedSuccessDialog()),

  // My Properties

  VGuard(
    beforeEnter: (vRedirector) async {
      print(
          '#log newVRouterData queryParameters: ${vRedirector.newVRouterData!.queryParameters}');

      if (FirebaseAuth.instance.currentUser ==
          null) {
        return vRedirector
            .to(LoginPath, queryParameters: {
          "redirect": MyPropertiesScreenPath,
        });
      } else {
        return null;
      }
    },
    stackedRoutes: [
      VWidget(
        path: MyPropertiesScreenPath,
        widget: MyPropertiesScreen(),
      ),
    ],
  ),
];
