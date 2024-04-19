import 'package:flutter/material.dart';
import 'package:payload_detecter/Providers/wagonController.dart';
import 'package:payload_detecter/constants/constants.dart';
import 'package:payload_detecter/constants/responsive.dart';
import 'package:payload_detecter/global.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    var wagonProvider = Provider.of<wagonController>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 500,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wagons Report ${wagonProvider.trainId}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor,
            ),
          ),
          Expanded(
            child: wagonProvider.list.isEmpty &&
                    !wagonProvider.isClick &&
                    !wagonProvider.connectionLost
                ? Center(
                    child: Text(
                    "Wagon On The Way..!",
                    style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 20
                            : Responsive.isDesktop(context)
                                ? 35
                                : 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26),
                  ))
                : wagonProvider.connectionLost
                    ? Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Connection lost ! please check the wifi",
                            style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 13
                                    : Responsive.isDesktop(context)
                                        ? 35
                                        : 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26),
                          ),
                          IconButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    wagonProvider.connectionLost = false;
                                    wagonProvider.fetchingdata = true;
                                    wagonProvider.isClick = true;
                                  });
                                  await wagonProvider.getWeightFromServer();
                                } catch (error) {
                                  print(error);
                                } finally {
                                  setState(() {
                                    wagonProvider.fetchingdata = false;
                                    wagonProvider.isClick = false;
                                    wagonProvider.connectionLost = true;
                                  });
                                }
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ))
                    : wagonProvider.isClick && wagonProvider.fetchingdata
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: wagonProvider.list
                                .length, // Replace with your actual list of images
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  children: [
                                    wagonProvider.list[index] >
                                            GlobalData().OverLoad
                                        ? Image.asset(
                                            'assets/images/wagon image.png', // Use Image.asset for local assets
                                            width: 700,
                                            height: 300,
                                            fit: BoxFit.fitHeight,
                                          )
                                        : wagonProvider.list[index] <
                                                GlobalData().underload
                                            ? Image.asset(
                                                'assets/images/underweight.png', // Use Image.asset for local assets
                                                width: 700,
                                                height: 300,
                                                fit: BoxFit.fitHeight,
                                              )
                                            : Image.asset(
                                                'assets/images/wagon correct weight.png', // Use Image.asset for local assets
                                                width: 700,
                                                height: 300,
                                                fit: BoxFit.fitHeight,
                                              ),
                                    Row(children: [
                                      Text(
                                        "wagon number :${wagonProvider.wagonId}",
                                      ),
                                      SizedBox(
                                        width: 60,
                                      ),
                                      Text(
                                        "weight = ${wagonProvider.list[index]}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 60,
                                      ),
                                      wagonProvider.list[index] >
                                              GlobalData().OverLoad
                                          ? Text(
                                              "Overload",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : wagonProvider.list[index] <
                                                  GlobalData().underload
                                              ? Text("underload",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : Text(
                                                  "Exact Load",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                    ])
                                  ],
                                ),
                              );
                            },
                          ),
            //child: BarChartUsers(),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      wagonProvider.fetchingdata = true;
                      wagonProvider.isClick = true;
                    });
                    await wagonProvider.getWeightFromServer();
                  } catch (error) {
                    print(error);
                  } finally {
                    setState(() {
                      wagonProvider.connectionLost = true;
                      wagonProvider.fetchingdata = false;
                      wagonProvider.isClick = false;
                    });
                  }
                },
                child: Text("start"),
              ),
              SizedBox(
                width: 60,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wagonProvider.isClick = true;
                      wagonProvider.fetchingdata = false;
                      wagonProvider
                          .clear(context)
                          .whenComplete(() => wagonProvider.isClick = false);
                      wagonProvider.connectionLost = false;
                    });
                  },
                  child: Text("update"))
            ],
          )
        ],
      ),
    );
  }
}
