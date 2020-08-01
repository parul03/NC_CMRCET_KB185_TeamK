import 'package:flutter/material.dart';

import 'package:sih/result.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'models/models.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Submission"),
      ),
      body: SlidingUpPanel(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
        minHeight: height / 16,
        maxHeight: height - 100,
        body: Column(
          children: [
            Flexible(child: Result(quizQuestions, false)),
            SizedBox(
              height: height / 6,
            )
          ],
        ),
        panel: SlidingUpPanel(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Your Remarks",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Divider(),
                SizedBox(
                  height: height / 16,
                ),
                Text(
                  remarks,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Your Images",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Divider(),
              SizedBox(
                height: height / 16,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: imageUrl.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: height / 2,
                          width: width,
                          color: Colors.black,
                          child: Image.network(
                            imageUrl[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
