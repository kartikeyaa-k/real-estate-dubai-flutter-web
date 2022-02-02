import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/footer.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../components/sliver_grid_delegate.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../property_detail/components/primary_detail.dart';
import '../cubit/completed_service_cubit.dart';
import 'my_services_mobile_card.dart';

class MyCompletedServicesTabView extends StatefulWidget {
  MyCompletedServicesTabView({Key? key}) : super(key: key);

  @override
  _MyCompletedServicesTabViewState createState() => _MyCompletedServicesTabViewState();
}

class _MyCompletedServicesTabViewState extends State<MyCompletedServicesTabView> {
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
    var throttler = Throttler(throttleGapInMillis: 1000);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Tablet and Desktop section
          BlocConsumer<CompletedServiceCubit, CompletedServiceState>(
            buildWhen: (previous, current) => previous.services != current.services,
            listenWhen: (previous, current) => previous.serviceIsSatisfiedStatus != current.serviceIsSatisfiedStatus,
            listener: (context, state) {
              if (state.serviceIsSatisfiedStatus.isSubmissionSuccess) {
                context.read<CompletedServiceCubit>().loadCompletedServices();
              }
            },
            builder: (context, state) {
              final completedService = state.services;

              if (state.status.isSubmissionSuccess) {
                if (completedService.isEmpty)
                  return Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight - Insets.footerSize,
                    child: Center(child: Text("No Completed Service Found")),
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
                      mainAxisMinExtent: Responsive.isMobile(context) ? 243 : mainAxisMinExtent,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: Responsive.isMobile(context) ? 328 / 310 : 370 / 350,
                    ),
                    itemCount: completedService.length,
                    itemBuilder: (context, index) {
                      final item = completedService[index];

                      return _RequestedServiceCard(
                        image: item.imageLink,
                        title: item.serviceName,
                        description: item.description,
                        isQuestionAnswered: item.isQuestionAnswered,
                        quotationText: item.quotation,
                        chips: [
                          Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text("Complete", style: TextStyles.body10.copyWith(color: Colors.white)),
                              backgroundColor: kSupportBlue)
                        ],
                        onDisSatisfied: () {
                          throttler.run(() {
                            context
                                .read<CompletedServiceCubit>()
                                .tenantSatisfation(serviceRequestId: item.serviceRequestId, isSatisfied: 0);
                          });
                        },
                        onSatisfied: () {
                          throttler.run(() {
                            context
                                .read<CompletedServiceCubit>()
                                .tenantSatisfation(serviceRequestId: item.serviceRequestId, isSatisfied: 1);
                          });
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
    this.childAspectRatio = 370 / 382;
    this.mainAxisMinExtent = 343;
    this.maxCrossAxisExtent = 500;

    this.mobileCard = MyServicesMobileCard(
      imageUrl: "https://images.indianexpress.com/2019/12/Home-Decor-2020-Trends_759.jpg",
      text: "House Cleaning",
      cost: "AED 120/Hr",
    );
  }
}

class _RequestedServiceCard extends StatelessWidget {
  const _RequestedServiceCard({
    Key? key,
    this.cost,
    this.image,
    this.title = "Home Decor",
    this.description = "",
    this.chips,
    required this.onDisSatisfied,
    required this.onSatisfied,
    required this.isQuestionAnswered,
    required this.quotationText,
  }) : super(key: key);

  final String? cost;
  final String? image;
  final String title;
  final String description;
  final List<Widget>? chips;
  final VoidCallback onDisSatisfied;
  final VoidCallback onSatisfied;
  final bool isQuestionAnswered;
  final String quotationText;

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
              padding: EdgeInsets.all(Insets.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyles.body12.copyWith(color: kBlackVariant.withOpacity(0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isQuestionAnswered) ...[
                    Spacer(),
                    Text("Are you Satisfied with the service?"),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        PrimaryOutlinedButton(
                          onTap: onDisSatisfied,
                          text: "Not Statisfied",
                          width: null,
                          height: Responsive.isMobile(context) ? 30 : 48,
                          fontSize: Responsive.isMobile(context) ? 12 : 16,
                        ),
                        SizedBox(width: Responsive.isMobile(context) ? 8 : 16),
                        PrimaryButton(
                            onTap: onSatisfied,
                            text: "Satisfied",
                            width: null,
                            height: Responsive.isMobile(context) ? 30 : 48,
                            fontSize: Responsive.isMobile(context) ? 12 : 16)
                      ],
                    )
                  ] else ...[
                    Spacer(),
                    Text(quotationText, style: TextStyles.h4)
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
