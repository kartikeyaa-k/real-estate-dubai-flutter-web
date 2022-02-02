import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/screens/my_services/cubit/booked_service_cubit.dart';
import 'package:real_estate_portal/screens/my_services/cubit/quoted_service_cubit.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/footer.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../components/sliver_grid_delegate.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../cubit/requested_service_cubit.dart';
import 'my_service_time_picker.dart';
import 'my_services_mobile_card.dart';

class MyQuotedServicesTabView extends StatefulWidget {
  MyQuotedServicesTabView({Key? key}) : super(key: key);

  @override
  _MyQuotedServicesTabViewState createState() => _MyQuotedServicesTabViewState();
}

class _MyQuotedServicesTabViewState extends State<MyQuotedServicesTabView> {
  late Widget mobileCard;
  late double maxCrossAxisExtent;
  late double mainAxisMinExtent;
  late double childAspectRatio;

  @override
  void initState() {
    super.initState();
    initailizeCards();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Tablet and Desktop section
          BlocBuilder<QuotedServiceCubit, QuotedServiceState>(
            buildWhen: (previous, current) => previous.services != current.services,
            builder: (context, state) {
              final requestedService = state.services;

              if (state.status.isSubmissionSuccess) {
                if (requestedService.isEmpty)
                  return Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight - Insets.footerSize,
                    child: Center(child: Text("No Quoted Service Found")),
                  );

                return Padding(
                  padding: Responsive.isMobile(context)
                      ? EdgeInsets.symmetric(vertical: 16, horizontal: 16)
                      : EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset),
                  child: GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
                      maxCrossAxisExtent: maxCrossAxisExtent,
                      mainAxisMinExtent: Responsive.isMobile(context) ? 280 : mainAxisMinExtent,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: Responsive.isMobile(context) ? 328 / 280 : childAspectRatio,
                    ),
                    itemCount: requestedService.length,
                    itemBuilder: (context, index) {
                      final item = requestedService[index];

                      return _QuotedServiceCard(
                        image: item.imageLink,
                        title: item.serviceName,
                        description: item.description,
                        cost: item.quotation,
                        chips: [
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text("Requested", style: TextStyles.body10.copyWith(color: Colors.white)),
                            backgroundColor: kSupportBlue,
                          )
                        ],
                        topButtonText: "Select Time",
                        onViewDetails: () async {
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: context.read<BookedServiceCubit>(),
                                child: MyServiceTimeSlotDialog(serviceRequestId: item.serviceRequestId),
                              );
                            },
                          );

                          context.read<QuotedServiceCubit>().loadQuoutedService();
                        },
                      );
                    },
                  ),
                );
              }

              return Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight - Insets.footerSize,
                child: Center(child: SpinKitThreeBounce(color: kSupportBlue)),
              );
            },
          ),

          // Footer
          if (Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }

  initailizeCards() {
    this.childAspectRatio = 370 / 293;
    this.mainAxisMinExtent = 343;
    this.maxCrossAxisExtent = 500;

    this.mobileCard = MyServicesMobileCard(
      imageUrl: "https://images.indianexpress.com/2019/12/Home-Decor-2020-Trends_759.jpg",
      text: "House Cleaning",
      cost: "AED 120/Hr",
    );
  }
}

class _QuotedServiceCard extends StatelessWidget {
  const _QuotedServiceCard({
    Key? key,
    this.cost,
    this.image,
    this.title = "Home Decor",
    this.description = "",
    this.buttonText = "Reschedule",
    this.topButtonText = "View Details",
    this.chips,
    this.onViewDetails,
  }) : super(key: key);

  final String? cost;
  final String? image;
  final String title;
  final String description;
  final String topButtonText;
  final String buttonText;
  final List<Widget>? chips;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: Corners.xlBorder, color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: Responsive.isMobile(context) ? 328 / 154 : 370 / 200,
            child: Stack(
              children: [
                SkeletonImageLoader(
                  image: image ??
                      "https://www.rocketmortgage.com/resources-cmsassets/RocketMortgage.com/Article_Images/Large_Images/TypesOfHomes/contemporary-house-style-9.jpg",
                  borderRadius: BorderRadius.vertical(top: Corners.xlRadius),
                ),
                Positioned(
                  top: Insets.xl,
                  left: Insets.xl,
                  child: Wrap(children: chips ?? []),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Spacer(),
                  Text(
                    description,
                    style: TextStyles.body12.copyWith(color: kBlackVariant.withOpacity(0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      if (cost != null) Expanded(flex: 8, child: Text("$cost", style: TextStyles.h4)),
                      Spacer(),
                      PrimaryButton(
                          onTap: onViewDetails ?? () {}, text: topButtonText, fontSize: 12, height: null, width: null)
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
