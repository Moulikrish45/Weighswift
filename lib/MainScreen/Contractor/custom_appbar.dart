import 'package:flutter/material.dart';
import 'package:payload_detecter/Providers/controller.dart';
import 'package:payload_detecter/constants/constants.dart';
import 'package:payload_detecter/constants/responsive.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: context.read<Controller>().controlMenu,
            icon: Icon(
              Icons.menu,
              color: textColor.withOpacity(0.5),
            ),
          ),
        
      ],
    );
  }
}
