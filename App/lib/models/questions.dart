class Question {
  String question;
  int score;
  String questionId;

  Question(this.questionId, this.question);

  void setScore(int score) {
    if (score >= 1 && score <= 10) {
      this.score = score;
    }
  }
}

class Questions {
  List<Question> questions = [
    new Question("q001",
        "1. How would you rate the drinking water facility at the school?"),
    new Question(
        "q002", "2. How would you rate the cleanliness at the school?"),
    new Question("q003",
        "3. How would you rate the desks count for students at the school?"),
    new Question("q004", "4. How would you rate the fan count at the school?"),
    new Question(
        "q005", "5. How would you rate the hygiene condition at the school?"),
  ];

  int currentQuestion = 0;

  void setCurrentScore(int score) {
    questions[currentQuestion].setScore(score);
  }

  String getCurrentQuestion() {
    return questions[currentQuestion].question;
  }

  bool isCurrentScoreSet() {
    return questions[currentQuestion].score != null;
  }

  bool allScoresSet() {
    for (Question q in questions) {
      if (q.score == null) {
        return false;
      }
    }
    return true;
  }

  void printAll() {
    for (int i = 0; i < 5; i++) {
      print(questions[i].question + "  " + questions[i].score.toString());
    }
  }
}
