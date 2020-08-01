import 'package:flutter/material.dart';

class ScoreButtons extends StatelessWidget {
  final Function setScore;
  final Function goForward;
  ScoreButtons(this.setScore, this.goForward);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // padding: EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 5,
      children: List.generate(10, (index) {
        // return Image.asset("assets/icons/10.png");
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.withOpacity(0.7), Colors.indigo],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.indigo, width: 4),
          ),
          child: FlatButton(
            onPressed: () {
              setScore(index + 1);
              goForward();
            },
            child: Container(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
