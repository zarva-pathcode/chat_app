import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppConfig {
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static GoogleSignInAccount? currentUser;
  static CollectionReference? usersCollection;
}
