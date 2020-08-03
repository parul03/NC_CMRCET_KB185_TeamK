import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:sih/models/models.dart';
import 'package:sih/quizpage.dart';
import 'package:sih/reports.dart';
// import 'package:sih/screens/quiz.dart';
import 'package:sih/widgets/counter.dart';
import 'package:sih/widgets/my_header.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'constant.dart';
import 'package:geodesy/geodesy.dart';

import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng l1, l2;
  final controller = ScrollController();
  double offset = 0;
  int here;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  @override
  void initState() {
    here = 0;
    // TODO: implement initState
    data = List();
    super.initState();
    controller.addListener(onScroll);
    checkTask();
    // here = 3;
    setState(() {});
  }

  String date = "";

  checkTask() async {
    FirebaseDatabase.instance
        .reference()
        .child("Tasks")
        .child(GlobalUser.no)
        .once()
        .then((value) {
      schoolCode = value.value["schoolCode"];
      date = value.value["date"];
    }).whenComplete(() {
      DateTime dat = DateTime.now();
      String da = DateTime.now().toString();
      print(da);
      RegExp exp = new RegExp(r"(\d\d\d\d)-(\d\d)-(\d\d)");
      Iterable<Match> matches = exp.allMatches(da);
      print("mathces" +
          matches.elementAt(0).group(3) +
          matches.elementAt(0).group(2) +
          matches.elementAt(0).group(1));

      da = matches.elementAt(0).group(3) +
          "/" +
          matches.elementAt(0).group(2) +
          "/" +
          matches.elementAt(0).group(1);
      print(dat.day.toString() +
          "/" +
          dat.month.toString() +
          "/" +
          dat.year.toString());

      FirebaseDatabase.instance
          .reference()
          .child("Schools")
          .child(schoolCode)
          .child("name")
          .once()
          .then((value) {
        schoolName = value.value;
      }).whenComplete(() {
        setState(() {});
      });

      if (date == da)
        getLocation();
      else
        here = 2;
      setState(() {});
    });
    print(date);
  }

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    var x = calculateDistance(
        _locationData.latitude, _locationData.longitude, 28.318491, 78.920935);
    print("this is distance  " + x.toString());
    if (x <= 0.8) {
      here = 3;
    } else {
      // here = 2;

      //!!  *********  TDOD   **************************
      here = 3;
    }
    setState(() {});
    // print(c);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    print("Dispose");
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  List<double> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: here == 3
          ? SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      MyHeader(
                        image: "assets/icons/teacher.svg",
                        textTop: "",
                        textBottom: "",
                        offset: offset,
                      ),
                      SafeArea(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(right: 20),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return InfoScreen();
                                    },
                                  ),
                                ).whenComplete(() {
                                  print(quizQuestions);
                                  if (quizQuestions.length != 0) {
                                    print(quizQuestions);
                                    for (var x in quizQuestions) {
                                      if (x.result == "t") {
                                        data.add(9);
                                      } else if (x.result == "f") {
                                        data.add(0);
                                      } else {
                                        data.add(double.parse(x.result) + 1);
                                      }
                                    }
                                    // data.sort();
                                  }
                                  print(data);
                                  setState(() {});
                                });
                              },
                              child: SvgPicture.asset("assets/icons/menu.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: [
                            SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(schoolName),
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 20),
                        // Expanded(
                        //   child: DropdownButton(
                        //     isExpanded: true,
                        //     underline: SizedBox(),
                        //     icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                        //     value: schoolCode,
                        //     items: [
                        //       'XYZ School',
                        //       'abc school',
                        //       'dfe school',
                        //     ].map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //     onChanged: (value) {},
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Academic Evaluation \n",
                                    style: kTitleTextstyle,
                                  ),
                                  TextSpan(
                                    text: "50 Questions",
                                    style: TextStyle(
                                      color: kTextLightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                print("yeah");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return InfoScreen();
                                  },
                                )).whenComplete(() {
                                  if (quizQuestions.length != 0) {
                                    for (var x in quizQuestions) {
                                      if (x.result == "t") {
                                        data.add(9);
                                      } else if (x.result == "f") {
                                        data.add(0);
                                      } else {
                                        data.add(double.parse(x.result) + 1);
                                      }
                                    }
                                    // data.sort();
                                  }

                                  setState(() {});
                                });
                              },
                              child: Text(
                                "Start quiz",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Counter(
                                color: GlobalUser.quiz == false
                                    ? kDeathColor
                                    : kRecovercolor,
                                number: GlobalUser.quiz == false
                                    ? "Incomplete"
                                    : "Quiz",
                                title: GlobalUser.quiz == false
                                    ? "Quiz"
                                    : "Completed",
                              ),
                              Counter(
                                color: GlobalUser.photo == false
                                    ? kDeathColor
                                    : kRecovercolor,
                                number: GlobalUser.photo == false
                                    ? "Incomplete"
                                    : "Photo",
                                title: GlobalUser.photo == false
                                    ? "Photo"
                                    : "Completed",
                              ),
                              Counter(
                                color: GlobalUser.remark == false
                                    ? kDeathColor
                                    : kRecovercolor,
                                number: GlobalUser.remark == false
                                    ? "Incomplete"
                                    : "Remarks",
                                title: GlobalUser.remark == false
                                    ? "Remarks"
                                    : "Completed",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Current Reports",
                              style: kTitleTextstyle,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return Reports();
                                  },
                                ));
                              },
                              child: Text(
                                "Check Reports",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(20),
                          height: 178,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          // child: Image.asset(
                          //   "assets/images/inde.png",
                          //   fit: BoxFit.fill,
                          // ),
                          child: data.length != 0
                              ? new Sparkline(
                                  data: data.length == 0 ? [0, 0] : data,
                                  lineColor: Colors.lightGreen[500],
                                  fillMode: FillMode.below,
                                  fillColor: Colors.lightGreen[200],
                                  pointsMode: PointsMode.all,
                                  pointSize: 5.0,
                                  pointColor: Colors.amber,
                                )
                              : Container(
                                  child: Text("Report"),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : here == 2
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You are not at rigth place"),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "You have to go school whose school code is $schoolCode on $date",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await MapsLauncher.launchCoordinates(
                              37.4220041, -122.0862462);
                        },
                        child: Text(
                          "Click here to see the location",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
