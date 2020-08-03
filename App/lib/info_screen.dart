import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sih/quizpage.dart';
import 'package:sih/remark_screen.dart';
import 'package:sih/reports.dart';
import 'package:sih/take_images.dart';
import 'package:sih/widgets/my_header.dart';
import 'package:image_picker/image_picker.dart';
import 'constant.dart';
import 'models/models.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/teacher.svg",
              textTop: "",
              textBottom: "",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Final Submit",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print(GlobalUser.quiz);
                          // GlobalUser.quiz
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return QuizPage();
                            },
                          )).whenComplete(() {
                            setState(() {});
                          });
                          // : Container();
                        },
                        child: SymptomCard(
                          image: "assets/images/c.png",
                          title: "Quiz",
                          isActive: GlobalUser.quiz,
                        ),
                      ),
                      InkWell(
                        onTap: GlobalUser.quiz == true
                            ? () async {
                                print("Upload");
                                var pickerdFile = await ImagePicker()
                                    .getImage(source: ImageSource.camera);
                                pickerdFile != null
                                    ? Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) {
                                          return Images(
                                            pickedFile: File(pickerdFile.path),
                                          );
                                        },
                                      ))
                                    : Container();
                                // showDialog(
                                //   context: context,
                                //   builder: (context) {
                                //     // return AlertDialog(
                                //     //   content: Text("Take Images from"),
                                //     //   actions: [
                                //     //     RaisedButton(
                                //     //       child: Text("Gallery"),
                                //     //       onPressed: () async {
                                //     //         var pickerdFile = await ImagePicker()
                                //     //             .getImage(
                                //     //                 source: ImageSource.gallery);
                                //     //         Navigator.of(context).pop();

                                //     //         pickerdFile != null
                                //     //             ? Navigator.of(context)
                                //     //                 .push(MaterialPageRoute(
                                //     //                 builder: (context) {
                                //     //                   return Images(
                                //     //                     pickedFile:
                                //     //                         File(pickerdFile.path),
                                //     //                   );
                                //     //                 },
                                //     //               ))
                                //     //             : null;
                                //     //       },
                                //     //       color: Colors.blue,
                                //     //     ),
                                //     //     RaisedButton(
                                //     //       child: Text("Camera"),
                                //     //       onPressed: () async {

                                //     //             : null;
                                //     //       },
                                //     //       color: Colors.blue,
                                //     //     ),
                                //     //   ],
                                //     // );
                                //   },
                                // );
                              }
                            : null,
                        child: SymptomCard(
                          image: "assets/images/a.png",
                          title: "Upload ",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          GlobalUser.remark == false
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return Remark();
                                  },
                                ))
                              : Container();
                        },
                        child: SymptomCard(
                          image: "assets/images/contract.png",
                          title: "Remarks",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Reports();
                            },
                          ));
                        },
                        child: SymptomCard(
                          image: "assets/images/check.png",
                          title: "Your\nCopy",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("About the App", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  PreventCard(
                    text:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                    image: "assets/images/wear_mask.png",
                    title: "How to use App?",
                  ),
                  PreventCard(
                    text:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ",
                    image: "assets/images/wash_hands.png",
                    title: "FAQ",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset("assets/icons/forward.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 85, width: 50),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
