import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/scaffold/sliver_scaffold.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/project_detail/cubit/timeslot_cubit.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../injection_container.dart';
import 'set_weekday.dart';

class AvailableTimeSlotDialog
    extends StatelessWidget {
  const AvailableTimeSlotDialog(
      {Key? key, required this.propertyId})
      : super(key: key);
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimeSlotCubit>(
        create: (context) => sl<TimeSlotCubit>(),
        child:
            TimeSlotView(propertyId: propertyId));
  }
}

class TimeSlotView extends StatefulWidget {
  const TimeSlotView(
      {Key? key, required this.propertyId})
      : super(key: key);
  final String propertyId;

  @override
  State<TimeSlotView> createState() =>
      _TimeSlotViewState();
}

class _TimeSlotViewState
    extends State<TimeSlotView> {
  List<TimeSlotModel> fetchedList = [];
  List<TimeSlotModel> filteredList = [];
  bool isLoading = true;
  bool isBooking = false;
  bool failure = false;
  String errorMessage = '';
  String bookingErrorMessaage = '';
  String selectedDay = '';
  late int time_slot_id = -1;
  String selectedDate = '';
  DateTime selectedDateTime = DateTime.now();
  DateTime currentMonth = DateTime.now();
  String strCurrentMonth =
      DateFormat('MMMM').format(DateTime.now());
  @override
  void initState() {
    selectedDate =
        appDateFormatter(DateTime.now());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    // if (!context.vRouter.queryParameters.keys.contains("property_id")) {
    // } else {
    // int propertyId = int.parse(context.vRouter.queryParameters["property_id"] as String);
    // context.read<TimeSlotCubit>().getTimeSlot(int.parse(widget.propertyId));
    // }
    context.read<TimeSlotCubit>().getTimeSlot(
        int.parse(widget.propertyId));
  }

  @override
  Widget build(BuildContext context) {
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;

    List<DropdownMenuItem<String>>?
        _dropdownMenuItems = [
      DropdownMenuItem<String>(
        value: 'GMT',
        child: Row(
          children: [
            SizedBox(height: 10, width: 8),
            Text('GMT'),
          ],
        ),
      )
    ];

    Widget _headerSubheader = Column(
      children: [
        Text("Select Available Timeslot",
            textAlign: TextAlign.center,
            style: TextStyles.h2),
        Text(
          "Your meeting will be booked according to the selected time slot",
          textAlign: TextAlign.center,
          style: TextStyles.body16.copyWith(
              color:
                  kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.sm),
        // calendar and time slot row
      ],
    );

    _mobileContent() {
      return IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(
              left: mobileLeftRightPadding,
              right: mobileLeftRightPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Insets.xxl,
                  ),
                  // Text(
                  //   'Select Time Zone',
                  //   style: TextStyles.smallestBlueText,
                  // ),
                  // SizedBox(
                  //   height: Insets.xs,
                  // ),
                  // Container(
                  //   height: hp(7),
                  //   child: DropdownButtonFormField<String>(
                  //     decoration: new InputDecoration(
                  //       hintStyle: TextStyles.body12,
                  //       isDense: true,
                  //       contentPadding: EdgeInsets.only(top: 12, bottom: 12, right: 5, left: 5),
                  //       enabledBorder: const OutlineInputBorder(
                  //         borderSide: const BorderSide(color: kSupportBlue, width: 1.0),
                  //       ),
                  //       border: const OutlineInputBorder(),
                  //     ),
                  //     iconEnabledColor: kSupportBlue,
                  //     iconDisabledColor: kSupportBlue,
                  //     hint: Text('Select Time Zone'),
                  //     value: 'GMT',
                  //     onChanged: (newValue) {},
                  //     icon: Icon(Icons.arrow_drop_down),
                  //     items: _dropdownMenuItems,
                  //     isDense: true,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: Insets.med,
                  // ),
                  Text(
                    'Select Date',
                    style: TextStyles
                        .smallestBlackText,
                  ),
                  SizedBox(
                    height: Insets.xs,
                  ),
                  Container(
                    height: 300,
                    child:
                        CalendarCarousel<Event>(
                      isScrollable: false,
                      onDayPressed:
                          (date, events) {
                        print(
                            '#log : Day pressed => ${DateFormat(DateFormat.WEEKDAY).format(date)}');
                        setState(() {
                          selectedDateTime = date;
                          selectedDate =
                              appDateFormatter(
                                  date);
                          filteredList =
                              setWeekday(
                                  weekday:
                                      selectedDay,
                                  list:
                                      fetchedList);
                        });
                        print(
                            '#log : Date pressed => $selectedDate');
                      },
                      onRightArrowPressed: () {
                        setState(() {
                          currentMonth =
                              currentMonth.add(
                                  Duration(
                                      days: 30));
                          strCurrentMonth =
                              DateFormat('MMMM')
                                  .format(
                                      currentMonth);
                        });
                      },
                      onLeftArrowPressed: () {
                        setState(() {
                          currentMonth =
                              currentMonth
                                  .subtract(
                                      Duration(
                                          days:
                                              30));
                          strCurrentMonth =
                              DateFormat('MMMM')
                                  .format(
                                      currentMonth);
                        });
                      },
                      selectedDateTime:
                          selectedDateTime,
                      daysTextStyle: TextStyle(
                          color: Colors.black),
                      headerTextStyle: TextStyle(
                          color: Colors.black),
                      weekdayTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      leftButtonIcon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      rightButtonIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      weekendTextStyle: TextStyle(
                          color: Colors.black),

                      //          weekDays: null, /// for pass null when you do not want to render weekDays
                      showHeader: true,
                      headerText: strCurrentMonth,
                      weekFormat: false,

                      showIconBehindDayText: true,
                      //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                      customGridViewPhysics:
                          NeverScrollableScrollPhysics(),
                      markedDateShowIcon: true,
                      markedDateIconMaxShown: 2,

                      selectedDayTextStyle:
                          TextStyle(
                        color: Colors.red,
                      ),
                      disableDayPressed: false,
                      selectedDayButtonColor:
                          kSupportBlue,
                      todayTextStyle: TextStyle(
                        color: Colors.red,
                      ),
                      markedDateIconBuilder:
                          (event) {
                        return event.icon ??
                            Icon(Icons
                                .help_outline);
                      },

                      minSelectedDate:
                          DateTime.now(),
                      maxSelectedDate:
                          DateTime.now().add(
                              Duration(
                                  days: 360)),
                      todayButtonColor:
                          Colors.transparent,
                      todayBorderColor:
                          Colors.green,
                      markedDateMoreShowTotal:
                          true, // null for not showing hidden events indicator
                      //          markedDateIconMargin: 9,
                      //          markedDateIconOffset: 3,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  filteredList.isEmpty
                      ? Container(
                          height: hp(10),
                          child: Center(
                            child: Text(
                              'Time slots are not available for $selectedDay',
                              textAlign: TextAlign
                                  .center,
                              style: TextStyles
                                  .smallestBlueText,
                            ),
                          ),
                        )
                      : Container(
                          height: hp(8),
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount:
                                  filteredList
                                      .length,
                              shrinkWrap: true,
                              scrollDirection:
                                  Axis.horizontal,
                              itemBuilder:
                                  (context,
                                      index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      time_slot_id =
                                          filteredList[index]
                                              .timeSlotId;
                                    });
                                  },
                                  child:
                                      Container(
                                          height: hp(
                                              7),
                                          width: wp(
                                              40),
                                          margin: EdgeInsets.only(
                                              right: filteredList.length - 1 == index
                                                  ? 0
                                                  : Insets
                                                      .sm),
                                          decoration: BoxDecoration(
                                              color: time_slot_id == filteredList[index].timeSlotId
                                                  ? kSupportBlue
                                                  : kBackgroundColor,
                                              border: Border.all(
                                                  color:
                                                      kSupportBlue),
                                              borderRadius: BorderRadius.circular(
                                                  5.0)),
                                          padding:
                                              EdgeInsets.all(
                                                  6),
                                          child:
                                              Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: time_slot_id == filteredList[index].timeSlotId ? kPlainWhite : kBlackVariant,
                                              ),
                                              SizedBox(
                                                width: Insets.sm,
                                              ),
                                              Text(
                                                '${filteredList[index].fromTime} - ${filteredList[index].toTime}',
                                                style: TextStyle(
                                                  color: time_slot_id == filteredList[index].timeSlotId ? kPlainWhite : kBlackVariant,
                                                ),
                                              ),
                                              // Spacer(),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     setState(() {
                                              //       time_slot_id = filteredList[index].timeSlotId;
                                              //     });
                                              //   },
                                              //   child: Card(
                                              //       elevation: 0,
                                              //       shape: RoundedRectangleBorder(
                                              //         borderRadius: BorderRadius.circular(5.0),
                                              //       ),
                                              //       color: time_slot_id == filteredList[index].timeSlotId
                                              //           ? kSupportBlue
                                              //           : Color(0xFFF8F6FF),
                                              //       child: Padding(
                                              //         padding: const EdgeInsets.all(6.0),
                                              //         child: Row(
                                              //           children: [
                                              //             Icon(
                                              //               Icons.calendar_today_rounded,
                                              //               color: time_slot_id == filteredList[index].timeSlotId
                                              //                   ? kBackgroundColor
                                              //                   : kSupportBlue,
                                              //               size: 13,
                                              //             ),
                                              //             SizedBox(
                                              //               width: Insets.sm,
                                              //             ),
                                              //             Text(
                                              //               'Book Slot',
                                              //               style: time_slot_id == filteredList[index].timeSlotId
                                              //                   ? TextStyles.smallestWhiteText
                                              //                   : TextStyles.smallestBlueText,
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       )),
                                              // )
                                            ],
                                          )),
                                );
                              }),
                        ),
                  mobileVerticalLargerSizedBox,
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      PrimaryButton(
                        onTap: () {
                          // context.vRouter.to(PropertyDetailScreenPath, queryParameters: {"id": widget.propertyId});
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                        height: 45,
                        width: 110,
                        fontSize: 12,
                      ),
                      SizedBox(width: Insets.xs),
                      PrimaryButton(
                        onTap: () {
                          print(
                              '#log : View -> ${time_slot_id} & ${selectedDate}');
                          if (time_slot_id !=
                                  -1 &&
                              selectedDate !=
                                  '') {
                            context
                                .read<
                                    TimeSlotCubit>()
                                .bookTimeSlot(
                                    time_slot_id:
                                        time_slot_id,
                                    date:
                                        selectedDate);
                          }
                        },
                        text: "Book Slot",
                        height: 45,
                        width: 110,
                        fontSize: 12,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return Responsive.isMobile(context)
        ? SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  leading: context.vRouter
                          .historyCanBack()
                      ? BackButton(
                          color: kBlackVariant,
                          onPressed: () {
                            if (context.vRouter
                                .historyCanBack()) {
                              return context
                                  .vRouter
                                  .historyBack();
                            }
                          })
                      : null,
                  backgroundColor: Colors.white,
                  title: Text(
                    'Select Time Slot',
                    style: MS.lableBlack,
                  ),
                  actions: [],
                ),
                body: BlocListener<TimeSlotCubit,
                    TimeSlotState>(
                  listener: (context, state) {
                    if (state is LTimeSlot) {
                    } else if (state
                        is FTimeSlot) {
                      setState(() {
                        isLoading = false;
                        failure = true;
                        errorMessage = state
                            .failure.errorMessage;
                      });
                    } else if (state
                        is STimeSlot) {
                      setState(() {
                        isLoading = false;
                        failure = false;
                        fetchedList =
                            state.result ?? [];
                        selectedDay = DateFormat(
                                DateFormat
                                    .WEEKDAY)
                            .format(
                                DateTime.now());
                        print(
                            '#log : weekday ======> $selectedDate');
                        filteredList.addAll(
                            setWeekday(
                                weekday:
                                    selectedDay,
                                list: state
                                        .result ??
                                    []));
                      });
                    } else if (state
                        is LBookTimeSlot) {
                      setState(() {
                        isBooking = true;
                      });
                    } else if (state
                        is FBookTimeSlot) {
                      setState(() {
                        isBooking = false;
                      });
                      final errorSnackBar =
                          CustomSnackBar
                              .errorSnackBar(state
                                  .failure
                                  .errorMessage);
                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(
                              errorSnackBar)
                          .closed
                          .then((value) =>
                              ScaffoldMessenger
                                      .of(context)
                                  .clearSnackBars());
                    } else if (state
                        is SBookTimeSlot) {
                      setState(() {
                        isBooking = false;
                      });
                      // THIS PAGE ACHIVES SUCCESS HERE ############################################
                      context.vRouter.to(
                          BookedTimeSlotDialogPath,
                          queryParameters: {
                            'property_id':
                                widget.propertyId
                          });
                    }
                  },
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
                      color: kPlainWhite,
                      child: _mobileContent()),
                )))
        : Scaffold(
            backgroundColor:
                Colors.black.withOpacity(0.7),
            body: Dialog(
                child: BlocListener<TimeSlotCubit,
                    TimeSlotState>(
              listener: (context, state) {
                if (state is LTimeSlot) {
                } else if (state is FTimeSlot) {
                  setState(() {
                    isLoading = false;
                    failure = true;
                    errorMessage = state
                        .failure.errorMessage;
                  });
                } else if (state is STimeSlot) {
                  setState(() {
                    isLoading = false;
                    failure = false;
                    fetchedList =
                        state.result ?? [];
                    DateTime date =
                        DateTime.now();
                    String dateFormat =
                        DateFormat('EEEE')
                            .format(date);
                    print('#log : $dateFormat');
                    selectedDay = dateFormat;

                    filteredList.addAll(
                        setWeekday(
                            weekday: selectedDay,
                            list: state.result ??
                                []));
                    print(
                        '#log : filtered : ${filteredList.toString()}');
                  });
                } else if (state
                    is LBookTimeSlot) {
                  setState(() {
                    isBooking = true;
                  });
                } else if (state
                    is FBookTimeSlot) {
                  setState(() {
                    isBooking = false;
                  });
                  final errorSnackBar =
                      CustomSnackBar
                          .errorSnackBar(state
                              .failure
                              .errorMessage);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(errorSnackBar)
                      .closed
                      .then((value) =>
                          ScaffoldMessenger.of(
                                  context)
                              .clearSnackBars());
                } else if (state
                    is SBookTimeSlot) {
                  setState(() {
                    isBooking = false;
                  });
                  // THIS PAGE ACHIVES SUCCESS HERE ############################################
                  context.vRouter.to(
                      BookedTimeSlotDialogPath,
                      queryParameters: {
                        'property_id':
                            widget.propertyId
                      });
                }
              },
              child: isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : failure
                      ? SizedBox(
                          child: Text(
                              '$errorMessage'))
                      : Container(
                          width: wp(50),
                          height: hp(95),
                          padding: EdgeInsets.all(
                              Insets.xl),
                          child: Stack(
                            children: [
                              Column(children: [
                                _headerSubheader,
                                SizedBox(
                                  height:
                                      Insets.med,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child:
                                            Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   'Select Time Zone',
                                            //   style: TextStyles.smallestBlueText,
                                            // ),
                                            // SizedBox(
                                            //   height: Insets.xs,
                                            // ),
                                            // Container(
                                            //   height: hp(7),
                                            //   child: DropdownButtonFormField<String>(
                                            //     decoration: new InputDecoration(
                                            //       hintStyle: TextStyles.body12,
                                            //       isDense: true,
                                            //       contentPadding:
                                            //           EdgeInsets.only(top: 12, bottom: 12, right: 5, left: 5),
                                            //       enabledBorder: const OutlineInputBorder(
                                            //         borderSide: const BorderSide(color: kSupportBlue, width: 1.0),
                                            //       ),
                                            //       border: const OutlineInputBorder(),
                                            //     ),
                                            //     iconEnabledColor: kSupportBlue,
                                            //     iconDisabledColor: kSupportBlue,
                                            //     hint: Text('Select Time Zone'),
                                            //     value: 'GMT',
                                            //     onChanged: (newValue) {},
                                            //     icon: Icon(Icons.arrow_drop_down),
                                            //     items: _dropdownMenuItems,
                                            //     isDense: true,
                                            //   ),
                                            // ),
                                            // SizedBox(
                                            //   height: Insets.med,
                                            // ),
                                            Text(
                                              'Select Date',
                                              style:
                                                  TextStyles.smallestBlackText,
                                            ),
                                            SizedBox(
                                              height:
                                                  Insets.xs,
                                            ),
                                            Container(
                                              height:
                                                  hp(50),
                                              child:
                                                  CalendarCarousel<Event>(
                                                showHeaderButton: true,
                                                headerTitleTouchable: true,
                                                onDayPressed: (date, events) {
                                                  print('#log : Day pressed => ${DateFormat(DateFormat.WEEKDAY).format(date)}');
                                                  setState(() {
                                                    selectedDateTime = date;
                                                    selectedDay = DateFormat(DateFormat.WEEKDAY).format(date);
                                                    print('#log tapped day ===> ${selectedDay}');
                                                    filteredList = setWeekday(weekday: selectedDay, list: fetchedList);
                                                  });
                                                  print('#log : filtered listt => ${filteredList.toString()}');
                                                },
                                                onRightArrowPressed: () {
                                                  setState(() {
                                                    currentMonth = currentMonth.add(Duration(days: 30));
                                                    strCurrentMonth = DateFormat('MMMM').format(currentMonth);
                                                  });
                                                },
                                                onLeftArrowPressed: () {
                                                  setState(() {
                                                    currentMonth = currentMonth.subtract(Duration(days: 30));
                                                    strCurrentMonth = DateFormat('MMMM').format(currentMonth);
                                                  });
                                                },
                                                showOnlyCurrentMonthDate: true,
                                                selectedDateTime: selectedDateTime,
                                                daysTextStyle: TextStyle(color: Colors.black),
                                                headerTextStyle: TextStyle(color: Colors.black),
                                                weekdayTextStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                leftButtonIcon: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.black,
                                                ),
                                                rightButtonIcon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black,
                                                ),
                                                weekendTextStyle: TextStyle(color: Colors.black),

                                                //          weekDays: null, /// for pass null when you do not want to render weekDays
                                                showHeader: true,
                                                headerText: strCurrentMonth,
                                                weekFormat: false,

                                                showIconBehindDayText: true,
                                                //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border

                                                markedDateShowIcon: true,
                                                markedDateIconMaxShown: 2,

                                                selectedDayTextStyle: TextStyle(
                                                  color: Colors.red,
                                                ),
                                                disableDayPressed: false,
                                                selectedDayButtonColor: kSupportBlue,
                                                todayTextStyle: TextStyle(
                                                  color: Colors.red,
                                                ),
                                                markedDateIconBuilder: (event) {
                                                  return event.icon ?? Icon(Icons.help_outline);
                                                },

                                                minSelectedDate: DateTime.now().subtract(Duration(days: 360)),
                                                maxSelectedDate: DateTime.now().add(Duration(days: 360)),
                                                todayButtonColor: Colors.transparent,
                                                todayBorderColor: Colors.green,
                                                markedDateMoreShowTotal: true, // null for not showing hidden events indicator
                                                //          markedDateIconMargin: 9,
                                                //          markedDateIconOffset: 3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                          thickness:
                                              1,
                                          indent:
                                              20,
                                          endIndent:
                                              40,
                                          width:
                                              50,
                                          color: kSupportBlue
                                              .withOpacity(0.1)),
                                      Expanded(
                                        flex: 5,
                                        child:
                                            Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            filteredList.isEmpty
                                                ? Container(
                                                    height: hp(70),
                                                    child: Center(
                                                      child: Text(
                                                        'Time slots are not available for $selectedDay',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyles.smallestBlueText,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: hp(70),
                                                    child: ListView.builder(
                                                        itemCount: filteredList.length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (context, index) {
                                                          return Container(
                                                              height: hp(7),
                                                              margin: EdgeInsets.only(bottom: filteredList.length - 1 == index ? 0 : Insets.sm),
                                                              decoration: BoxDecoration(border: Border.all(color: kSupportBlue), borderRadius: BorderRadius.circular(5.0)),
                                                              padding: EdgeInsets.all(6),
                                                              child: Row(
                                                                children: [
                                                                  Icon(Icons.timer),
                                                                  SizedBox(
                                                                    width: Insets.sm,
                                                                  ),
                                                                  Text('${filteredList[index].fromTime} - ${filteredList[index].toTime}'),
                                                                  Spacer(),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        time_slot_id = filteredList[index].timeSlotId;
                                                                      });
                                                                    },
                                                                    child: Card(
                                                                        elevation: 0,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                        ),
                                                                        color: time_slot_id == filteredList[index].timeSlotId ? kSupportBlue : Color(0xFFF8F6FF),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(6.0),
                                                                          child: Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.calendar_today_rounded,
                                                                                color: time_slot_id == filteredList[index].timeSlotId ? kBackgroundColor : kSupportBlue,
                                                                                size: 13,
                                                                              ),
                                                                              SizedBox(
                                                                                width: Insets.sm,
                                                                              ),
                                                                              Text(
                                                                                'Book Slot',
                                                                                style: time_slot_id == filteredList[index].timeSlotId ? TextStyles.smallestWhiteText : TextStyles.smallestBlueText,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  )
                                                                ],
                                                              ));
                                                        }),
                                                  ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                PrimaryButton(
                                                  onTap: () {
                                                    context.vRouter.to(PropertyDetailScreenPath, queryParameters: {
                                                      "id": widget.propertyId
                                                    });
                                                  },
                                                  text: "Cancel",
                                                  height: 45,
                                                  width: 110,
                                                  fontSize: 12,
                                                ),
                                                SizedBox(width: Insets.xs),
                                                PrimaryButton(
                                                  onTap: () {
                                                    print('#log : View -> ${time_slot_id} & ${selectedDate}');
                                                    if (time_slot_id != -1 && selectedDate != '') {
                                                      context.read<TimeSlotCubit>().bookTimeSlot(time_slot_id: time_slot_id, date: selectedDate);
                                                    }
                                                  },
                                                  text: "Book Slot",
                                                  height: 45,
                                                  width: 110,
                                                  fontSize: 12,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                              Align(
                                alignment:
                                    Alignment
                                        .topLeft,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(
                                          context);
                                      // context.vRouter.to(PropertyDetailScreenPath, queryParameters: {
                                      //   "id": context.vRouter.queryParameters["property_id"] as String
                                      // });
                                    },
                                    child: Icon(
                                        Icons
                                            .close,
                                        size:
                                            20)),
                              )
                            ],
                          ),
                        ),
            )),
          );
  }
}
