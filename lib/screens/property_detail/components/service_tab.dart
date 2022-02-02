import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/footer.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../home/components/title_row.dart';
import '../../my_services/components/my_services_card.dart';
import '../../services/cubit/service_cubit.dart';
import '../../services/cubit/service_main_cubit.dart';

class ServiceTab extends StatefulWidget {
  const ServiceTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ServiceTab> {
  late ScrollController _emergencyScrollController;
  late ScrollController _otherScrollController;

  @override
  void initState() {
    super.initState();
    _emergencyScrollController = ScrollController();
    _otherScrollController = ScrollController();
  }

  @override
  void dispose() {
    _emergencyScrollController.dispose();
    _otherScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ServiceCubit>().getOtherServices();
    context.read<ServiceCubit>().getFacilityMngServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listener: (context, state) {
        if (state.serviceRequestStatus.isSubmissionSuccess) {
          showDialog(
            context: context,
            builder: (_) {
              return _SuccessDailog();
            },
          );
        }
      },
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 16 : Insets.offset,
              vertical: Responsive.isMobile(context) ? 16 : Insets.xxl,
            ),
            child: Column(
              children: [
                BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, state) {
                    if (state.facilityServiceStatus.isSubmissionInProgress)
                      return SpinKitThreeBounce(color: kSupportBlue);

                    if (state.facilityServiceStatus.isSubmissionSuccess)
                      return Column(
                        key: Key("facility-service-column-key"),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleRow(
                            scrollController: _emergencyScrollController,
                            listItemCount: state.facilityServices.length,
                            // count: "${state.result.length.toInt()}",
                            title: "Facility Management Services",
                          ),
                          SizedBox(height: Insets.lg),
                          Container(
                            height: 344,
                            child: ListView.builder(
                              controller: _emergencyScrollController,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: state.facilityServices.length,
                              itemBuilder: (context, index) {
                                final service = state.facilityServices[index];

                                return Padding(
                                  padding: EdgeInsetsDirectional.only(end: 28),
                                  child: AspectRatio(
                                    aspectRatio: Responsive.isMobile(context) ? 320 / 343 : 370 / 343,
                                    child: MyServicesCard(
                                      image: service.images.isEmpty ? null : service.images.first,
                                      title: service.serviceName,
                                      description: service.serviceDescription ?? "",
                                      onViewDetails: () async {
                                        bool? result = await showDialog<bool>(
                                          context: context,
                                          builder: (_) {
                                            return _ConfirmationDialog();
                                          },
                                        );

                                        if (result ?? false) {
                                          context.read<ServiceCubit>().createRequest(
                                                propertyId: int.parse(context.vRouter.queryParameters["id"]!),
                                                serviceId: service.id,
                                              );
                                        }
                                      },
                                      topButtonText: "Book Service",
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );

                    // If failure
                    return Text("Unable to communicate to server");
                  },
                ),

                // Other Services
                SizedBox(height: Insets.lg),
                BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, state) {
                    if (state.otherServiceStatus.isSubmissionInProgress) return SpinKitThreeBounce(color: kSupportBlue);

                    if (state.otherServiceStatus.isSubmissionSuccess)
                      return Column(
                        key: Key("other-service-column-key"),
                        children: [
                          TitleRow(
                            scrollController: _otherScrollController,
                            listItemCount: state.otherServices.length,
                            // count: "10",
                            title: "Other Services",
                          ),
                          SizedBox(height: Insets.lg),
                          Container(
                            height: 344,
                            alignment: Alignment.centerLeft,
                            child: ListView.builder(
                              controller: _otherScrollController,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: state.otherServices.length,
                              itemBuilder: (context, index) {
                                final service = state.otherServices[index];

                                return Padding(
                                  padding: EdgeInsetsDirectional.only(end: 28),
                                  child: AspectRatio(
                                    aspectRatio: Responsive.isMobile(context) ? 320 / 343 : 370 / 343,
                                    child: MyServicesCard(
                                      image: service.images.isEmpty ? null : service.images.first,
                                      title: service.serviceName,
                                      description: service.serviceDescription ?? "",
                                      onViewDetails: () async {
                                        bool? result = await showDialog<bool>(
                                          context: context,
                                          builder: (_) {
                                            return _ConfirmationDialog();
                                          },
                                        );

                                        if (result ?? false) {
                                          context.read<ServiceCubit>().createRequest(
                                                propertyId: int.parse(context.vRouter.queryParameters["id"]!),
                                                serviceId: service.id,
                                              );
                                        }
                                      },
                                      topButtonText: "Book Service",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );

                    if (state is FOtherServicesMain) return Text(state.failureMessage);

                    // If failure
                    return Text("Unable to communicate to server other services");
                  },
                ),
              ],
            ),
          ),
          if (Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }

  Row _titleRow(
    BuildContext context,
    String title,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: TextStyles.h2,
          ),
        ),
        Spacer(),
        if (!Responsive.isMobile(context)) ...[
          InkWell(
            child: Text(
              "See All(200)",
              style: TextStyles.body12.copyWith(color: kSupportBlue),
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward_ios_sharp,
              size: 18,
            ),
          ),
        ] else
          InkWell(
            child: Text(
              "See All(200)",
              style: TextStyles.body12.copyWith(color: kSupportBlue),
            ),
          ),
      ],
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Dialog(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.5,
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Confirmation", style: TextStyles.h2),
                SizedBox(height: 8),
                Text("Please confirm and book this service."),
                SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    PrimaryOutlinedButton(
                      text: "Cancel",
                      onTap: () {
                        Navigator.pop<bool>(context, false);
                      },
                    ),
                    SizedBox(width: 16),
                    PrimaryButton(
                      text: "Confirm",
                      onTap: () {
                        Navigator.pop<bool>(context, true);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessDailog extends StatelessWidget {
  const _SuccessDailog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Widget _headerSubheader = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Confirmation", textAlign: TextAlign.center, style: TextStyles.h2),
        SizedBox(height: Insets.xs),
        Text(
          "Are you sure you want to book this service.",
          textAlign: TextAlign.center,
          style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.sm),

        // calendar and time slot row
      ],
    );
    Widget body = SizedBox(
      height: hp(30),
      width: wp(10),
      child: Image.asset(
        'assets/timeslot/time_slot_confirmed.png',
        fit: BoxFit.cover,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Dialog(
        child: Container(
          height: hp(50),
          width: wp(32),
          alignment: Alignment.center,
          padding: EdgeInsets.all(Insets.xl),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_headerSubheader, body],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, size: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
