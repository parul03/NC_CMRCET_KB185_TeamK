import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  static DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  static Future<DataSnapshot> read(String path) async {
    return await dbRef.child(path).once();
  }

  static void write(String path, String json) async {
    await dbRef.child(path).set(json);
  }

  static void push(String path, String json) async {
    await dbRef.child(path).push().set(json);
  }
}
