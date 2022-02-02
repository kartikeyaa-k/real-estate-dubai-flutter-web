import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

class BookedConfirmationDialog extends StatelessWidget {
  const BookedConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
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
                      context.vRouter.to(
                        ProjectListingScreenPath,
                      );
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
