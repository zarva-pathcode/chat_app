import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future getUserByUsername(String username) async {
    return await db
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  upUserInfo(userMap) {
    db.collection("users").add(userMap);
  }
}
