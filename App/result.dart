import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sih/home.dart';
import 'models/models.dart';

class Result extends StatefulWidget {
  final bool i;
  final List<QuizQuestion> questions;
  Result(this.questions, this.i);

  @override
  _ResultState createState() => _ResultState(questions);
}

class _ResultState extends State<Result> {
  final List<QuizQuestion> questions;
  bool loading;

  _ResultState(this.questions);
  @override
  void initState() {
    loading = true;
    if (widget.i == true) put();
    super.initState();
  }

  put() async {
    String score = "";
    for (var q in questions) {
      score += q.result;
    }
    quizQuestions = questions;
    GlobalUser.key =
        FirebaseDatabase.instance.reference().child('Feedbacks').push();

    await GlobalUser.key.set(Feedbacks(
            "",
            DateTime.now().day.toString() +
                "/" +
                DateTime.now().month.toString() +
                "/" +
                DateTime.now().year.toString(),
            5682,
            GlobalUser.no,
            "",
            score)
        .toJson());

    FirebaseDatabase.instance
        .reference()
        .child("school_feedbacks")
        .child("1234")
        .update({GlobalUser.key.key.toString(): true});

    FirebaseDatabase.instance
        .reference()
        .child("user_feedbacks")
        .child(GlobalUser.no)
        .set({GlobalUser.key.key.toString(): true}).whenComplete(() {
      setState(() {
        loading = false;
      });
    });

    GlobalUser.quiz = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.i == true ? Colors.blue : Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: widget.i == true ? true : false,
        title: Text(
          widget.i == true ? "Thankyou for your feedback!" : "Your Quizes",
          style:
              TextStyle(color: widget.i == true ? Colors.white : Colors.black),
        ),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            // onTap: () {
            //   widget.questionsController.currentQuestion = index + 1;
            //   Navigator.pop(context);
            // },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(questions[index].type == 0
                      ? (int.parse(questions[index].result) + 1).toString()
                      : questions[index].result),
                ),
                title: Text(
                  questions[index].question,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        },
        itemCount: questions.length,
      )),
    );
  }
}
