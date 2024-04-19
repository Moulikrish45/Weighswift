import 'package:flutter/material.dart';
import 'package:payload_detecter/MainScreen/Contractor/analytic_info_card.dart';
import 'package:payload_detecter/Providers/wagonController.dart';
import 'package:payload_detecter/constants/constants.dart';
import 'package:payload_detecter/constants/responsive.dart';
import 'package:provider/provider.dart';


class AnalyticCards extends StatelessWidget {
  AnalyticCards({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridView(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridView(),
        desktop: AnalyticInfoCardGridView(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatefulWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridView> createState() =>
      _AnalyticInfoCardGridViewState();
}

class _AnalyticInfoCardGridViewState extends State<AnalyticInfoCardGridView> {
  List<Map<String, dynamic>> analyticData = [
    {
      "title": "Over Loading",
      "count": '0',
      "svgSrc": "assets/icons/train-svgrepo-com.svg",
      "color": primaryColor,
    },
    {
      "title": "Under Loading",
      "count": '0',
      "svgSrc": "assets/icons/train-svgrepo-com (3).svg",
      "color": purple,
    },
    {
      "title": "No of wagons Crossed",
      "count": '0',
      "svgSrc": "assets/icons/list-svgrepo-com.svg",
      "color": orange,
    },
    {
      "title": "Total Weight",
      "count": '0',
      "svgSrc": "assets/icons/weight-svgrepo-com.svg",
      "color": green,
    },
  ];
  @override
  Widget build(BuildContext context) {
    var wagonProvider = Provider.of<wagonController>(context);

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: analyticData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: appPadding,
        mainAxisSpacing: appPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        title: analyticData[index]['title'],
        count: getCountValue(index, wagonProvider),
        svgSrc: analyticData[index]['svgSrc'],
        color: analyticData[index]['color'],
      ),
    );
  }


  String getCountValue(int index, wagonController wagonProvider) {
    switch (index) {
      case 0:
        return wagonProvider.overload.toString();
      case 1:
        return wagonProvider.underload.toString();
      case 2:
        return wagonProvider.totalwagon.toString();
      case 3:
        return wagonProvider.totalweight.toString();
      default:
        return '0';
    }
  }
}
