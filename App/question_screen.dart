import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final String questionText;

  QuestionScreen(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 20,
            spreadRadius: 10,
          )
        ],
        color: Colors
            .indigo, //(questionsController.currentQuestion * 100) % 400 + 400],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            questionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
