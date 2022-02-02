import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:formz/formz.dart';
import 'package:pagination_indicator/pagination_indicator.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/screens/project_listing/constants/project_list_contants.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/footer.dart';
import '../../../components/listing_cards/latest_card.dart';
import '../../../components/listing_cards/mobile_card.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/project_model/project_model.dart';
import '../../../routes/routes.dart';
import '../cubit/project_listing_cubit.dart';
import 'project_filter.dart';

class ProjectList extends StatelessWidget {
  ProjectList({
    Key? key,
    this.minPrice,
    this.maxPrice,
    this.keywords,
    this.amenityIds,
    this.keywordArray,
    this.limit,
    this.offset,
  }) : super(key: key);

  final double? minPrice;
  final double? maxPrice;
  final String? keywords;
  final List<String>? amenityIds;
  final List<String>? keywordArray;
  final int? limit;
  final int? offset;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: Responsive.isMobile(context) ? EdgeInsets.zero : null,
      children: [
        Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset)
              : EdgeInsets.zero,
          child: BlocBuilder<ProjectListingCubit, ProjectListingState>(
            builder: (context, state) {
              final List<ProjectModel> list = state.projectListModel.result.list;

              return Row(
                crossAxisAlignment: state.status.isSubmissionInProgress || list.isEmpty
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context)) ...[
                    Align(alignment: Alignment.topLeft, child: ProjectFilter(cubit: context.read())),
                    SizedBox(width: 30),
                  ],
                  BlocBuilder<ProjectListingCubit, ProjectListingState>(
                    builder: (context, state) {
                      if (state.status.isSubmissionInProgress)
                        return Expanded(child: Center(child: SpinKitThreeBounce(color: kSupportBlue)));

                      if (list.isEmpty)
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text("Ops! it seems we don't have property for these categories",
                                      style: TextStyles.h4),
                                  SizedBox(height: Insets.med),
                                  PrimaryOutlinedButton(
                                    width: 200,
                                    onTap: () {
                                      context.vRouter.to(context.vRouter.path, isReplacement: true);
                                      // context.read<ProjectListingCubit>().clearAllFilters();
                                    },
                                    text: "clear filters",
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

                      if (Responsive.isMobile(context))
                        return Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: list.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsetsDirectional.only(bottom: 2),
                              child: MobileCard(
                                address: list[index].areaCommunityDetails.communityName.en,
                                name: list[index].projectName.en,
                                price: list[index].pricePerSqFeet != null && list[index].pricePerSqFeet! > 0
                                    ? list[index].pricePerSqFeet!.toDouble()
                                    : null,
                                image: list[index]
                                    .projectImages
                                    .firstWhere((element) => element.isCover,
                                        orElse: () => list[index].projectImages[0])
                                    .link,
                                onTap: () => context.vRouter.to(
                                  ProjectDetailScreenPath,
                                  queryParameters: {"id": list[index].id.toString()},
                                ),
                              ),
                            ),
                          ),
                        );
                      else
                        return Flexible(
                          child: GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: Responsive.isMobile(context) ? 382 : 400,
                              mainAxisExtent: Responsive.isMobile(context) ? 445 : 360,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: Times.medium,
                                columnCount: list.length,
                                child: LatestCard(
                                  imageLink: list[index]
                                      .projectImages
                                      .firstWhere((element) => element.isCover,
                                          orElse: () => list[index].projectImages[0])
                                      .link,
                                  address: list[index].areaCommunityDetails.communityName.en,
                                  isVerified: list[index].isVerified,
                                  name: list[index].projectName.en,
                                  pricePerSqFeet: list[index].pricePerSqFeet != null && list[index].startingPrice > 0
                                      ? list[index].startingPrice
                                      : null,
                                  // status: list[index].status,
                                  totalUnits: list[index].totalUnits,
                                  onViewDetail: () => context.vRouter.to(
                                    ProjectDetailScreenPath,
                                    queryParameters: {"id": list[index].id.toString()},
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                    },
                  )
                ],
              );
            },
          ),
        ),
        Center(
          child: BlocBuilder<ProjectListingCubit, ProjectListingState>(
            builder: (context, state) {
              if (state.status.isSubmissionInProgress) {
                return Container();
              }

              int pageCount = (state.totalProjCount / kProjPerPage).ceil();
              int selectedPage = int.tryParse(context.vRouter.queryParameters[kProjPageNumberKey] ?? "1") ?? 1;
              return Row(
                children: [
                  Spacer(),
                  if (pageCount > 1 && selectedPage != 1)
                    PrimaryButton(
                      onTap: () {
                        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                        int currentPage = int.tryParse(updateQuery[kProjPageNumberKey] ?? "2") ?? 2;
                        int previousPage = currentPage - 1;
                        if (updateQuery.containsKey(kProjPageNumberKey)) {
                          updateQuery.update(kProjPageNumberKey, (_) => previousPage.toString());
                        } else {
                          updateQuery[kProjPageNumberKey] = previousPage.toString();
                        }
                        // replace the route
                        context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                      },
                      text: "Previous",
                      width: 100,
                    ),

                  // pages
                  SizedBox(width: 8),
                  PaginationIndicator(
                    pageCount: pageCount,
                    initialValue: selectedPage < 1 ? 1 : selectedPage,
                    visiblePageCount: 10,
                    onPageChanged: (index) {
                      Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                      if (updateQuery.containsKey(kProjPageNumberKey)) {
                        updateQuery.update(kProjPageNumberKey, (_) => ("${index + 1}").toString());
                      } else {
                        updateQuery[kProjPageNumberKey] = (index + 1).toString();
                      }
                      // replace the route
                      context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                    },
                  ),
                  SizedBox(width: 8),

                  if (state.totalProjCount > 10 && selectedPage != pageCount)
                    PrimaryButton(
                      onTap: () {
                        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                        int currentPage = int.tryParse(updateQuery[kProjPageNumberKey] ?? "1") ?? 1;
                        int nextPage = currentPage + 1;
                        if (updateQuery.containsKey(kProjPageNumberKey)) {
                          updateQuery.update(kProjPageNumberKey, (_) => ("$nextPage").toString());
                        } else {
                          updateQuery[kProjPageNumberKey] = nextPage.toString();
                        }
                        // replace the route
                        context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                      },
                      text: "Next",
                      width: 100,
                    ),
                  Spacer()
                ],
              );
            },
          ),
        ),
        SizedBox(height: 16),
        if (Responsive.isDesktop(context)) Footer()
      ],
    );
  }
}
