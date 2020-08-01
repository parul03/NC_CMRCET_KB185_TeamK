import 'package:flutter/material.dart';
import 'package:sih_feedback/question_screen.dart';
import 'package:sih_feedback/score_buttons.dart';
import './models/questions.dart';
import './result.dart';

//2nd change
//changed in 2nd branch

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void goBackward() {
    print("baack");
    if (questionsController.currentQuestion > 0) {
      setState(() {
        questionsController.currentQuestion -= 1;
      });
    }
  }

  void goForward() {
    print("forward");
    if (questionsController.currentQuestion ==
            questionsController.questions.length - 1 &&
        questionsController.allScoresSet()) {
      questionsController.printAll();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Result(questionsController)),
      ).then((value) => setState(() {
            questionsController.currentQuestion -= 1;
          }));
    } else if (questionsController.currentQuestion <
            questionsController.questions.length - 1 &&
        questionsController.isCurrentScoreSet()) {
      setState(() {
        questionsController.currentQuestion += 1;
      });
    }
  }

  void setScore(int score) {
    questionsController.setCurrentScore(score);
  }

  Questions questionsController;

  @override
  void initState() {
    super.initState();
    questionsController = new Questions();
  }

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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QuestionScreen(questionsController.getCurrentQuestion()),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: ScoreButtons(setScore, goForward),
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
                  IconButton(
                    //color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: goBackward,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: goForward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
