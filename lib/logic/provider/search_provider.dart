import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';

class SearchProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var isLoading = false;
  var friendsList = [];
  var searchList = [];

  void searchFriends(String data) async {
    if (data.isEmpty) {
      searchList.clear();
      friendsList.clear();
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      debugPrint(capitalized);
      if (searchList.isEmpty && data.length == 1) {
        CollectionReference users = firestore.collection("users");
        final keyNameRes = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: AppData.authData!.email)
            .get();
        if (keyNameRes.docs.isNotEmpty) {
          for (var i = 0; i < keyNameRes.docs.length; i++) {
            searchList.add(keyNameRes.docs[i].data() as Map<String, dynamic>);
          }
          debugPrint("SEARCH LIST RESULT :");
          debugPrint(searchList.toString());
        } else {
          debugPrint("TIDAK ADA DATA");
        }
      }

      if (searchList.isNotEmpty) {
        friendsList.clear();
        for (var element in searchList) {
          if (element['name'].startsWith(capitalized)) {
            friendsList.add(element);
            isLoading = false;
          } else {
            isLoading = false;
          }
        }
      }
    }
    notifyListeners();
  }
}
