import 'package:dio/dio.dart';
import 'package:firebase_authentication_repository/firebase_authentication_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:real_estate_portal/screens/community_detail/cubit/popular_building_location_cubit.dart';
import 'package:real_estate_portal/screens/my_properties/cubit/my_properties_cubit.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/verification_cubit.dart';
import 'package:real_estate_portal/screens/services/cubit/service_main_cubit.dart';
import 'package:real_estate_portal/services/community_guidelines_services/community_guidelines_services.dart';
import 'package:real_estate_portal/services/my_services/my_services_service.dart';
import 'package:real_estate_portal/services/services_main_services/services_main_service.dart';
import 'package:real_estate_portal/services/verification_status_services/verification_status_service.dart';
import 'core/interceptors/token_interceptor.dart';
import 'core/utils/validation_helper.dart';
import 'data/http_helper/Ihttp_helper.dart';
import 'data/http_helper/http_helper.dart';
import 'data/prefs_helper/iprefs_helper.dart';
import 'data/prefs_helper/prefs_helper.dart';
import 'data/repository/irepository.dart';
import 'data/repository/repository.dart';
import 'env/base_env.dart';
import 'screens/community_detail/cubit/community_building_cubit.dart';
import 'screens/community_detail/cubit/feautred_property_cubit.dart';
import 'screens/company_guidlines/cubit/community_cubit.dart';
import 'screens/cover_page/cubit/cover_page_cubit.dart';
import 'screens/facility_management/cubit/basic_info_facility_mng_cubit.dart';
import 'screens/home/cubit/home_cubit.dart';
import 'screens/home/filter_bloc/home_filter_bloc.dart';
import 'screens/login/cubit/login_cubit.dart';
import 'screens/login/cubit/phone_login_cubit.dart';
import 'screens/project_detail/cubit/book_status_cubit.dart';
import 'screens/project_detail/cubit/project_cubit.dart';
import 'screens/project_detail/cubit/timeslot_cubit.dart';
import 'screens/project_listing/cubit/project_listing_cubit.dart';
import 'screens/property_detail/cubit/offer_cubit.dart';
import 'screens/property_detail/cubit/property_cubit.dart';
import 'screens/property_listing/cubit/property_listing_cubit.dart';
import 'screens/service_providers/cubit/service_provider_cubit.dart';
import 'screens/signup/cubit/signup_cubit.dart';
import 'screens/signup/signup_form_bloc/signup_form_bloc.dart';
import 'services/book_status_services/book_status_services.dart';
import 'services/cover_page_services/cover_page_services.dart';
import 'services/home/home_services.dart';
import 'services/offer_services/offer_services.dart';
import 'services/project_services/project_services.dart';
import 'services/property_services/property_services.dart';
import 'services/service_provider_service/service_provider_services.dart';
import 'services/timeslot_services/book_time_slot_services.dart';
import 'services/timeslot_services/timeslot_services.dart';

final sl = GetIt.instance;
final Environment _env = Environment();

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<ValidationHelper>(() => ValidationHelperImpl());
  sl.registerSingleton(FirebaseAuthenticationRepository());

  //! External
  var options = BaseOptions(
    baseUrl: "${_env.config.baseUrl}",
    // connectTimeout: _env.config.connectTimeout,
    // receiveTimeout: _env.config.receiveTimeout,
    headers: {
      "Accept-Language": "en",
      'Content-Type': 'application/json',
    },
    responseType: ResponseType.plain,
  );

  Dio dio = Dio(options);
  dio.interceptors.add(TokenInterceptor(dio: dio));
  sl.registerLazySingleton(() => dio);

  // Repository, HttpHelper, PrefHelper
  sl.registerLazySingleton<IPrefsHelper>(() => PrefsHelper());
  sl.registerLazySingleton<IHttpHelper>(() => HttpHelper(dio: sl()));
  sl.registerLazySingleton<IRepository>(() => Repository(sl(), sl()));

  //! Services
  sl.registerLazySingleton<HomeServices>(() => HomeServicesImpl(dio: sl()));
  sl.registerLazySingleton<PropertyServices>(() => PropertyServicesImpl(dio: sl()));
  sl.registerLazySingleton<ProjectServices>(() => ProjectServicesImpl(dio: sl()));
  sl.registerLazySingleton<BookStatusServices>(() => BookStatusServicesImpl(dio: sl()));
  sl.registerLazySingleton<TimeSlotServices>(() => TimeSlotServicesImpl(dio: sl()));
  sl.registerLazySingleton<BookTimeSlotServices>(() => BookTimeSlotServicesImpl(dio: sl()));
  sl.registerLazySingleton<ServiceProviderServices>(() => ServiceProviderServicesImpl(dio: sl()));
  sl.registerLazySingleton<CoverPageService>(() => CoverPageServiceImpl(dio: sl()));
  sl.registerLazySingleton<OfferServices>(() => OfferServicesImpl(dio: sl()));
  sl.registerLazySingleton<CommunityGuidelineService>(() => CommunityGuidelineServiceImpl(dio: sl()));
  sl.registerLazySingleton<ServicesMainService>(() => ServicesMainServiceImpl(dio: sl()));
  sl.registerLazySingleton<MyServicesService>(() => MyServicesServiceImpl(dio: sl()));
  sl.registerLazySingleton<VerificationStatusService>(() => VerificationStatusServiceImpl(dio: sl()));

  //! Bloc and Cubit
  // * AUTHENTICATION BLoC
  sl.registerFactory(() => SignupFormBloc(validationHelper: sl(), httpHelper: sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => PhoneLoginCubit(sl()));
  sl.registerFactory(() => SignUpCubit(sl()));
  // * HOME BLoC
  sl.registerFactory(() => HomeFilterBloc(homeServices: sl()));
  sl.registerFactory(() => HomeCubit(homeServices: sl()));
  // * Facility BLoC
  sl.registerFactory(() => BasicInfoFacilityMngCubit(sl()));
  // * Property BLoC
  sl.registerFactory(() => PropertyListingCubit(homeServices: sl(), propertyServices: sl()));
  sl.registerFactory(() => PropertyDetailCubit(sl()));
  // * Project BLoC
  sl.registerFactory(() => ProjectListingCubit(homeServices: sl(), projectServices: sl()));
  sl.registerFactory(() => ProjectDetailCubit(projectServices: sl(), propertyServices: sl()));
  // * Timeslot BLocc
  sl.registerFactory(() => TimeSlotCubit(timeSlotServices: sl(), bookTimeSlotServices: sl()));
  // * Service Provider BLocc
  sl.registerFactory(() => ServiceProviderCubit(serviceProviderServices: sl()));
  // *  Cover Page Bloc
  sl.registerFactory(() => CoverPageCubit(coverPageService: sl()));
  // * Offer BLoc
  sl.registerFactory(() => OfferCubit(offerServices: sl()));
  // * Community Guideline BLoC
  sl.registerFactory(() => CommunityCubit(communityGuidelineService: sl()));
  sl.registerFactory(() => CommunityBuildingCubit(communityGuidelineService: sl()));
  sl.registerFactory(() => FeaturedPropertyCubit(propertyServices: sl()));
  sl.registerFactory(() => PopularBuildingLocationCubit(communityGuidelineService: sl()));
  //* Services Main
  sl.registerFactory(() => ServiceMainCubit(servicesMainService: sl()));
  //* Verification Status
  sl.registerFactory(() => VerificationCubit(verificationStatusService: sl()));
  //* My Properties
  sl.registerFactory(() => MyPropertiesCubit(propertyServices: sl()));
}
