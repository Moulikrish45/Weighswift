import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payload_detecter/constants/constants.dart';


class TrainInformation extends StatefulWidget {
  const TrainInformation({Key? key}) : super(key: key);

  @override
  State<TrainInformation> createState() => _TrainInformationState();
}

class _TrainInformationState extends State<TrainInformation>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool isloading = false;
  List<String> trainInformation = [];

  Future<void> fetchDataFromDocument(String documentName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Train Informations')
            .doc("userid : ${user.uid}")
            .collection('Train Details')
            .doc(documentName)
            .get();

        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          CollectionReference trainCollections = FirebaseFirestore.instance
              .collection('Train Informations')
              .doc("userid : ${user.uid}")
              .collection('Train Details')
              .doc(documentName)
              .collection('Wagon Details');
          QuerySnapshot collectionSnapshot = await trainCollections.get();

          List<DocumentSnapshot> documents = collectionSnapshot.docs;

          List<Map<String, dynamic>> dataList = [];

          for (DocumentSnapshot doc in documents) {
            Map<String, dynamic>? collectionData =
                doc.data() as Map<String, dynamic>?;

            if (collectionData != null) {
              dataList.add(collectionData);
            }
          }

         showDialog(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Data from Document'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data:'),
                      for (var entry in data.entries)
                        Text('${entry.key}: ${entry.value}'),
                      SizedBox(height: 10),
                      Text('DataList:'),
                      for (var item in dataList)
                        Row(
                          children: [
                            for (var entry in item.entries)
                              Expanded(
                                child: Text('${entry.key}: ${entry.value}'),
                              ),
                          ],
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      print("Error fetching data from document: $e");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> fetchTrainInformation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Train Informations')
            .doc("userid : ${user.uid}")
            .collection('Train Details')
            .get();

        List<String> documentNames =
            querySnapshot.docs.map((doc) => doc.id).toList();

        setState(() {
          trainInformation = documentNames;
        });
      }
      _rotationController.stop();
    } catch (e) {
      print("Error fetching train information: $e");
    }
  }

  void _initAnimation() {
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * 3.141).animate(_rotationController);
  }

  void _handleRefresh() {
    _rotationController.repeat();

    fetchTrainInformation();
  }

  @override
  void initState() {
    fetchTrainInformation();
    _initAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return isloading
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 175),
            child: Center(child: CircularProgressIndicator()))
        : Container(
            height: 350,
            padding: EdgeInsets.all(appPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Train Informations',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Icon(Icons.refresh),
                          );
                        },
                      ),
                      onPressed: _handleRefresh,
                    ),
                  ],
                ),
                SizedBox(
                  height: appPadding,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: trainInformation.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          isloading = true;
                        });
                        fetchDataFromDocument(trainInformation[index]);
                      },
                      child: ListTile(
                        title: Text(trainInformation[index]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
