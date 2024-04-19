import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payload_detecter/constants/constants.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({
    Key? key, required this.title, required this.count, required this.svgSrc, required this.color,
  }) : super(key: key);

  final String title;
  final String count;
  final String svgSrc;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appPadding,
        vertical: appPadding / 2,
      ),
      decoration: BoxDecoration(
          color: secondaryColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${count}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: EdgeInsets.all(appPadding / 2),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: SvgPicture.asset(
                  svgSrc,
                ),
              )
            ],
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
