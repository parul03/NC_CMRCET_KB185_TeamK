import 'package:firebase_database/firebase_database.dart';

class Feedbacks {
  String id;
  String date;
  int schoolCode;
  String submitterId;
  String notes;
  String feedback;
  Feedbacks(this.id, this.date, this.schoolCode, this.submitterId, this.notes,
      this.feedback);

  Feedbacks.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        date = snapshot.value["date"],
        schoolCode = snapshot.value["schoolCode"],
        submitterId = snapshot.value["submitterId"],
        notes = snapshot.value["notes"],
        feedback = snapshot.value["feedback"];

  toJson() {
    return {
      // "id": id,
      "date": date,
      "schoolCode": schoolCode,
      "submitterId": submitterId,
      "notes": notes,
      "feedback": feedback
    };
  }
}

class QuizQuestion {
  String result;
  String id;
  String date;
  int schoolCode;
  String submitterId;
  String notes;
  String question;
  int type;
  String assigneeId;
  List<String> options;
  QuizQuestion(this.id, this.date, this.schoolCode, this.submitterId,
      this.notes, this.question, this.type, this.options);

  QuizQuestion.fromSnapshot(var snapshot)
      : id = snapshot["id"],
        date = snapshot["date"],
        schoolCode = snapshot["schoolCode"],
        submitterId = snapshot["submitterId"],
        notes = snapshot["notes"],
        type = snapshot["type"],
        options = snapshot["options"],
        assigneeId = snapshot["assigneeId"],
        question = snapshot["question"];

  toJson() {
    return {
      "date": date,
      "schoolCode": schoolCode,
      "submitterId": submitterId,
      "notes": notes,
      "question": question,
      "options": options,
      "type": type,
      "assigneeId": assigneeId
    };
  }
}

class GlobalUser {
  static String name;
  static String uID;
  static bool isVerified;
  static String email;
  static String no = "9012220988";
  static bool remark = false;
  static bool quiz = false;
  static bool photo = false;
  static var key;
}

enum QuestionType { LONG, MCQ }
enum Roles { Admin, VisitingOfficial, Teacher, Student }

List<QuizQuestion> quizQuestions = List();
String remarks = "";
List<String> imageUrl = List();
