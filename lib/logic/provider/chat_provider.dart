import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:intl/intl.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int totalUnread = 0;

  Stream<QuerySnapshot<Map<String, dynamic>>> connectionStream(String email) {
    return firestore
        .collection("users")
        .doc(email)
        .collection("chatUser")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection("users").doc(email).snapshots();
  }

  newChat(String chatId, String message, String friendEmail,
      {Function()? chatAdded}) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    String dateNow = DateTime.now().toIso8601String();

    chats.doc(chatId).collection("chat").add({
      "time": dateNow,
      "sender": AppData.authData!.email,
      "receiver": friendEmail,
      "message": message,
      "isRead": false,
      "timeGroup": DateFormat.yMMMMd("en_US").format(DateTime.parse(dateNow)),
    });

    chatAdded!();

    await users
        .doc(AppData.authData!.email)
        .collection("chatUser")
        .doc(chatId)
        .update({
      "lastTime": dateNow,
    });

    final friendChatData =
        await users.doc(friendEmail).collection("chatUser").doc(chatId).get();

    if (friendChatData.exists) {
      //? update chat for friend in database
      final checkTotalUnread = await chats
          .doc(chatId)
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("sender", isEqualTo: AppData.authData!.email)
          .get();

      totalUnread = checkTotalUnread.docs.length;
      print("TOTAL UNREAD : $totalUnread");

      await users.doc(friendEmail).collection("chatUser").doc(chatId).update({
        "lastTime": dateNow,
        "total_unread": totalUnread,
      });
    } else {
      //? create chat for friend in database
      await users.doc(friendEmail).collection("chatUser").doc(chatId).set({
        "chat_id": chatId,
        "connection": AppData.authData!.email,
        "lastTime": dateNow,
        "total_unread": 1,
      });
    }
    notifyListeners();
  }

  goToChatRoom({String? chatId, Function(String)? onSuccess}) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final readChatUpdate = await chats
        .doc(chatId)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("receiver", isEqualTo: AppData.authData!.email)
        .get();

    readChatUpdate.docs.forEach((element) async {
      element.id;
      await chats.doc(chatId).collection("chat").doc(element.id).update({
        "isRead": true,
      });
    });

    await users
        .doc(AppData.authData!.email)
        .collection("chatUser")
        .doc(chatId)
        .update({
      "total_unread": 0,
    });
    onSuccess!(chatId!);
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String chatId) {
    CollectionReference chats = firestore.collection("chats");
    return chats
        .doc(chatId)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }
}
