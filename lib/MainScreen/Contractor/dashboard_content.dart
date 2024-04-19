import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payload_detecter/MainScreen/Contractor/TrainInformation.dart';
import 'package:payload_detecter/MainScreen/Contractor/analytic_cards.dart';
import 'package:payload_detecter/MainScreen/Contractor/custom_appbar.dart';
import 'package:payload_detecter/MainScreen/Contractor/users.dart';
import 'package:payload_detecter/constants/constants.dart';
import 'package:payload_detecter/constants/responsive.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            const CustomAppbar(),
            const SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          AnalyticCards(),
                          const SizedBox(
                            height: appPadding,
                          ),
                          Users(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  child: TrainInformation(),
                                  flex: 2,
                                ),
                              if (!Responsive.isMobile(context))
                                SizedBox(
                                  width: appPadding,
                                ),
                              // Expanded(
                              //   flex: 3,
                              //   child: Viewers(),
                              // ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          const SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) TrainInformation(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
