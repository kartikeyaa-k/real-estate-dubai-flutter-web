import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../cubit/booked_service_cubit.dart';

class MyServiceTimeSlotDialog extends StatefulWidget {
  const MyServiceTimeSlotDialog({Key? key, required this.serviceRequestId}) : super(key: key);
  final int serviceRequestId;

  @override
  State<MyServiceTimeSlotDialog> createState() => _MyServiceTimeSlotDialogState();
}

class _MyServiceTimeSlotDialogState extends State<MyServiceTimeSlotDialog> {
  late DateRangePickerController _dateRangePickerController;
  final List<String> timeList = List.generate(24, (index) {
    final time = index.toString().padLeft(2, "0");
    return "$time:00";
  });

  @override
  void initState() {
    super.initState();
    _dateRangePickerController = DateRangePickerController();
  }

  @override
  void dispose() {
    _dateRangePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _headerSubheader = Column(
      children: [
        Text("Book Your Service", textAlign: TextAlign.center, style: TextStyles.h2),
        Text(
          "Your service will be booked according to the selected time slot",
          textAlign: TextAlign.center,
          style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.sm),
        // calendar and time slot row
      ],
    );

    Widget timeSelectionColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter Prefered Time"),
        SizedBox(height: 20),
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("From", style: TextStyles.body14.copyWith(color: kSupportBlue)),
                    SizedBox(height: 8),
                    PrimaryDropdownButton<String>(
                      key: ValueKey("from-date"),
                      itemList: timeList.map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
                      onChanged: (time) {
                        context.read<BookedServiceCubit>().fromTimeEntered(time);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("To", style: TextStyles.body14.copyWith(color: kSupportBlue)),
                    SizedBox(height: 8),
                    PrimaryDropdownButton<String>(
                      key: ValueKey("to-date"),
                      itemList: timeList.map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
                      onChanged: (time) {
                        context.read<BookedServiceCubit>().toTimeEntered(time);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryOutlinedButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Cancel",
            ),
            SizedBox(width: 20),
            PrimaryButton(
              onTap: () {
                context.read<BookedServiceCubit>().rescheduleBookedService(widget.serviceRequestId);
              },
              text: "Send Request",
            )
          ],
        )
      ],
    );

    Widget rescheduleView = _RescheduleView(
        headerSubheader: _headerSubheader,
        dateRangePickerController: _dateRangePickerController,
        timeSelectionColumn: timeSelectionColumn);

    var animatedSwitcher = AnimatedSwitcher(
      duration: Times.fastest,
      child: BlocBuilder<BookedServiceCubit, BookedServiceState>(
        buildWhen: (previous, current) => previous.formStatus != current.formStatus,
        builder: (context, state) {
          return state.formStatus.isSubmissionSuccess ? _BookedConfirmationDialog() : rescheduleView;
        },
      ),
    );

    return BlocListener<BookedServiceCubit, BookedServiceState>(
      listenWhen: (previous, current) => previous.formStatus != current.formStatus,
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          SnackBar snackBar = CustomSnackBar.errorSnackBar(state.formFailureMessage);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Responsive.isMobile(context)
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: BackButton(
                  color: kBlackVariant,
                  onPressed: () {
                    context.read<BookedServiceCubit>().resetRescheduleState();
                    Navigator.pop(context);
                  },
                ),
                title: Text("Select Time Slot", style: TextStyles.h3),
              ),
              body: animatedSwitcher,
            )
          : FractionallySizedBox(
              heightFactor: 0.7,
              widthFactor: 0.5,
              child: ClipRRect(
                borderRadius: Corners.xlBorder,
                child: animatedSwitcher,
              ),
            ),
    );
  }
}

class _RescheduleView extends StatelessWidget {
  const _RescheduleView({
    Key? key,
    required Widget headerSubheader,
    required DateRangePickerController dateRangePickerController,
    required this.timeSelectionColumn,
  })  : _headerSubheader = headerSubheader,
        _dateRangePickerController = dateRangePickerController,
        super(key: key);

  final Widget _headerSubheader;
  final DateRangePickerController _dateRangePickerController;
  final Widget timeSelectionColumn;

  @override
  Widget build(BuildContext context) {
    var sfDateRangePicker = SfDateRangePicker(
      showNavigationArrow: true,
      enableMultiView: false,
      enablePastDates: false,
      controller: _dateRangePickerController,
      headerStyle: DateRangePickerHeaderStyle(textStyle: TextStyles.body12),
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(Duration(days: 365)),
      selectionMode: DateRangePickerSelectionMode.single,
      todayHighlightColor: Colors.white,
      selectionColor: kSupportBlue,
      navigationMode: DateRangePickerNavigationMode.snap,
      selectionTextStyle: TextStyles.body12.copyWith(color: Colors.white),
      monthCellStyle: DateRangePickerMonthCellStyle(todayTextStyle: TextStyles.body12.copyWith(color: kSupportBlue)),
      monthViewSettings: DateRangePickerMonthViewSettings(
        dayFormat: 'EEE',
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyles.body12.copyWith(color: Colors.teal),
        ),
      ),
      onSelectionChanged: (args) {
        if (args.value is DateTime) {
          context.read<BookedServiceCubit>().dateEntered(args.value);
        }
      },
    );

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _headerSubheader,
            SizedBox(height: 20),
            Flexible(
              child: Flex(
                direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                children: [
                  Expanded(child: sfDateRangePicker),
                  VerticalDivider(),
                  Expanded(child: timeSelectionColumn),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookedConfirmationDialog extends StatelessWidget {
  const _BookedConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _headerSubheader = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Slot Request Has been Sent", textAlign: TextAlign.center, style: TextStyles.h2),
        SizedBox(height: Insets.xs),
        Text(
          "Please wait for the agent to accept the meeting request",
          textAlign: TextAlign.center,
          style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.sm),

        // calendar and time slot row
      ],
    );

    return Material(
      color: Colors.white,
      child: Container(
        // height: hp(50),
        // width: wp(32),
        alignment: Alignment.center,
        padding: EdgeInsets.all(Insets.xl),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headerSubheader,
                Image.asset(
                  'assets/timeslot/time_slot_confirmed.png',
                  fit: BoxFit.cover,
                )
              ],
            ),
            if (!Responsive.isMobile(context))
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    context.read<BookedServiceCubit>().resetRescheduleState();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 20),
                ),
              )
          ],
        ),
      ),
    );
  }
}
