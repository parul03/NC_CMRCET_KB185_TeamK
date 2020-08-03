import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sih/question_screen.dart';
import './result.dart';
import 'models/models.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    loading = true;
    super.initState();
    questions = List();
    fetchQuiz();
  }

  bool loading;

  int i = 0;

  List<QuizQuestion> questions;

  fetchQuiz() async {
    FirebaseDatabase.instance
        .reference()
        .child("QuizQuestion")
        .once()
        .then((value) {
      print(value);
      print(value.value);
      for (var x in value.value) {
        questions.add(QuizQuestion.fromSnapshot(x));
      }
    }).whenComplete(() {
      print(questions);
      loading = false;
      setState(() {});
    });
  }

  void goBackward() {
    print("baack");
    if (i > 0) {
      setState(() {
        i -= 1;
      });
    }
  }

  void goForward() {
    print("forward");
    if (i == questions.length - 1) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Result(questions, true)),
      );
    } else {
      setState(() {
        i += 1;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   questionsController = new Questions();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: loading == false
            ? buildQuestions(context)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Column buildQuestions(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        QuestionScreen(questions[i].question),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: questions[i].type == 0
              ? GridView.count(
                  //padding: EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 5,
                  children: List.generate(10, (index) {
                    return InkWell(
                      onTap: () {
                        questions[i].result = (index).toString();
                        goForward();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: questions[i].result != (index).toString()
                                ? [Colors.lightBlueAccent, Colors.blue]
                                : [Colors.indigo, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: Colors.blue, width: 4),
                        ),
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        questions[i].result = "t";
                        goForward();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: questions[i].result != "t"
                                ? [Colors.lightBlueAccent, Colors.blue]
                                : [Colors.indigo, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Colors.blue, width: 4),
                        ),
                        child: Text(
                          "True",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        questions[i].result = "f";
                        goForward();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: questions[i].result != "f"
                                ? [Colors.lightBlueAccent, Colors.blue]
                                : [Colors.indigo, Colors.blue],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Colors.blue, width: 4),
                        ),
                        child: Text(
                          "False",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
        Container(
          height: 50,
          //color: Colors.indigo,
          //alignment: Alignment.bottomRight,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  //color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: goBackward,
                ),
              ),

              // IconButton(
              //   icon: Icon(
              //     Icons.arrow_forward,
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   onPressed: goForward,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
