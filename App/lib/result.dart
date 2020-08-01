import 'package:flutter/material.dart';
import './models/questions.dart';

class Result extends StatelessWidget {
  final Questions questionsController;
  Result(this.questionsController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check your feedback!"),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () {
              questionsController.currentQuestion = index + 1;
              Navigator.pop(context);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                      questionsController.questions[index].score.toString()),
                ),
                title: Text(
                  questionsController.questions[index].question,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
        itemCount: questionsController.questions.length,
      )),
    );
  }
}
