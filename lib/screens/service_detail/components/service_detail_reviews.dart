import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class ServiceDetailReviews extends StatelessWidget {
  const ServiceDetailReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _reviewTitle = Container(
      padding: EdgeInsets.fromLTRB(Insets.xxl, Insets.lg, Insets.xl, Insets.lg),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Text("Service Review", style: TextStyles.h4),
          Spacer(),
          Flexible(
            child: PrimaryDropdownButton(/*value: "dummy",*/ itemList: [DropdownMenuItem(child: Text("data"))]),
          ),
        ],
      ),
    );

    Widget _scoreBreakdown = Container(
      padding: EdgeInsets.all(Insets.xl),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Score Breakdown", style: TextStyles.h2),
          SizedBox(height: Insets.med),
          Text(
            "How do maintenance Score in the following Category?",
            style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
          ),
          SizedBox(height: Insets.xxl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _addRating("Maintainance", 3.5),
              _addRating("Staff/Security", 4.5),
              _addRating("Gym/Pool", 3),
              _addRating("Children Friendly", 5),
            ],
          )
        ],
      ),
    );

    Widget _reviews = Container(
      padding: EdgeInsets.all(Insets.xl),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reviews", style: TextStyles.h2),
          SizedBox(height: Insets.xxl),

          // Comment item
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: Responsive.isDesktop(context) ? 5 : 2,
            itemBuilder: (context, index) {
              return _commentItem();
            },
          ),
          Row(
            children: [
              Icon(Icons.keyboard_arrow_down, color: kDarkGrey),
              Text("See More", style: TextStyles.body14.copyWith(color: kDarkGrey)),
            ],
          )
        ],
      ),
    );

    return Container(
      decoration: !Responsive.isDesktop(context) ? null : BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reviewTitle,
          if (!Responsive.isDesktop(context)) SizedBox(height: Insets.med),
          if (Responsive.isMobile(context)) ...[_scoreBreakdown, _reviews] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 3, child: _scoreBreakdown),
                Container(
                    width: !Responsive.isDesktop(context) ? Insets.xl : 1,
                    color: !Responsive.isDesktop(context) ? Colors.transparent : Colors.black.withOpacity(0.1),
                    height: !Responsive.isDesktop(context) ? 20 : MediaQuery.of(context).size.height + 65),
                Flexible(flex: 5, child: _reviews)
              ],
            )
        ],
      ),
    );
  }

  // ======================================================================
  // Functions
  // ======================================================================

  Column _commentItem() {
    Widget _nameAndRating = Column(
      children: [
        Text("Jerome Bell", style: TextStyles.h3),
        SizedBox(height: Insets.sm),
        RatingBar.builder(
          ignoreGestures: true,
          itemSize: 18,
          initialRating: 4.5,
          itemCount: 5,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(Icons.star_rounded, color: kAccentColor[100]),
          onRatingUpdate: (rating) {},
        )
      ],
    );

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/app/dummy_avatar.png')),
            SizedBox(width: Insets.xl),
            _nameAndRating,
          ],
        ),
        SizedBox(height: Insets.xl),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Scelerisque purus velit interdum mi feugiat porta. TemporLorem ipsum dolor sit amet, consectetur adipiscing elit. Scelerisque purus velit interdum mi feugiat porta. Tempor  ",
          style: TextStyles.body14.copyWith(color: kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.xl),
      ],
    );
  }

  Row _addRating(String text, double rating) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(text, style: TextStyles.h5)),
        RatingBar.builder(
          ignoreGestures: true,
          itemSize: 18,
          initialRating: rating,
          itemCount: 5,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(Icons.star_rounded, color: kAccentColor[100]),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        SizedBox(width: Insets.med, height: 24),
        Text(rating.toString(), style: TextStyles.body14.copyWith(color: kAccentColor[100])),
        Spacer()
      ],
    );
  }
}
