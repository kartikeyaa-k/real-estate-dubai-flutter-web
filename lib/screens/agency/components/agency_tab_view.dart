import 'package:flutter/material.dart';

import '../../../components/footer.dart';
import '../../../components/listing_cards/featured_card.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class AgencyTabView extends StatefulWidget {
  AgencyTabView({Key? key}) : super(key: key);

  @override
  _AgencyTabViewState createState() => _AgencyTabViewState();
}

class _AgencyTabViewState extends State<AgencyTabView> {
  late ScrollController _scrollController;
  late ScrollController _innerScrollController;

  // bool hasMoved = false;

  // bool get moved {
  //   return _scrollController.hasClients && _scrollController.offset > 0;
  // }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0);
    _innerScrollController = ScrollController(initialScrollOffset: 0);
    // _scrollController.addListener(() {
    //   print("object");
    //   if (_scrollController.hasClients) print("offset moved ${_scrollController.offset}");

    //   // if (moved) {
    //   //   setState(() {
    //   //     _scrollController.jumpTo(0);
    //   //   });
    //   // }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _innerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Responsive.isDesktop(context) ? Insets.xxl : Insets.lg, horizontal: Insets.offset),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (Responsive.isDesktop(context)) PropertyFilter(),
                if (Responsive.isDesktop(context)) ...[
                  SizedBox(width: 30),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: Responsive.isDesktop(context) ? 394 : 382,
                        mainAxisExtent: Responsive.isDesktop(context) ? 459 : 445,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return FeaturedCard();
                      },
                    ),
                  )
                ]
              ],
            ),
          ),
          if (!Responsive.isDesktop(context))
            SingleChildScrollView(
              controller: _innerScrollController,
              physics: NeverScrollableScrollPhysics(parent: NeverScrollableScrollPhysics()),
              primary: false,
              child: Container(
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsetsDirectional.only(end: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(Insets.med),
                      child: FeaturedCard(),
                    );
                  },
                ),
              ),
            ),
          if (Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }
}
