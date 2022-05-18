import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:flutter_chat_app/logic/data/model/users.dart';
import 'package:flutter_chat_app/ui/helper/collection_ref.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoadingState {
  isWaiting,
  isDone,
}

enum AuthState {
  authenticating,
  authenticated,
  unauthenticating,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  LoadingState loadingState = LoadingState.isDone;
  AuthState authState = AuthState.unauthenticated;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleSignInAccount? _currentUser;
  GoogleSignInAuthentication? _authUser;
  UserCredential? userCredential;
  String? dateNow = DateTime.now().toIso8601String();
  Users? usersM = Users();

  Future<void> loginWithGoogle({
    Function(AuthState)? stateInfo,
    Function(String)? onError,
  }) async {
    try {
      authState = AuthState.authenticating;
      stateInfo!(authState);
      notifyListeners();
      debugPrint("=> SIGN OUT");
      await _googleSignIn.signOut();

      debugPrint("=> SIGN IN");
      _currentUser = await _googleSignIn.signIn();
      _authUser = await _currentUser!.authentication;

      debugPrint("=> GOOGLE AUTH CREDENTIAL");
      final credential = GoogleAuthProvider.credential(
        idToken: _authUser!.idToken,
        accessToken: _authUser!.accessToken,
      );
      debugPrint("=> GET USER CREDENTIAL");
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint("=> SET DATA TO FIRESTORE");
      CollectionReference users = firestore.collection(CollectionName.users);

      var checkUser = await users.doc(_currentUser!.email).get();

      if (checkUser.data() != null) {
        Map<String, dynamic> data = checkUser.data() as Map<String, dynamic>;
        await users.doc(_currentUser!.email).update({
          "lastSignInTime": dateNow,
        });

        AppData.setUserPreferences(
          email: userCredential!.user!.email,
          name: userCredential!.user!.displayName,
          photoUrl: userCredential!.user!.photoURL ?? "",
          status: data["status"],
        );
        authState = AuthState.authenticated;
        stateInfo(authState);
        notifyListeners();
      } else {
        users.doc(_currentUser!.email).set({
          "uid": userCredential!.user!.uid,
          "name": userCredential!.user!.displayName,
          "keyName":
              userCredential!.user!.displayName!.substring(0, 1).toUpperCase(),
          "email": userCredential!.user!.email,
          "photoUrl": userCredential!.user!.photoURL ?? "",
          "status": "",
          "creationTime":
              userCredential!.user!.metadata.creationTime!.toIso8601String(),
          "lastSignInTime": dateNow,
          "updatedTime": "",
          "chatUser": [],
        });

        AppData.setUserPreferences(
          email: userCredential!.user!.email,
          name: userCredential!.user!.displayName,
          photoUrl: userCredential!.user!.photoURL ?? "",
          status: "",
        );

        authState = AuthState.unauthenticated;
        stateInfo(authState);
        notifyListeners();
      }
    } catch (e) {
      loadingState = LoadingState.isDone;
      debugPrint(e.toString());
      // onError!(e.toString());
    }
    notifyListeners();
  }

  getProfile() async {
    CollectionReference users = firestore.collection('users');
    final currentUser = await users.doc(AppData.authData!.email).get();
    final currentUserData = currentUser.data() as Map<String, dynamic>;

    usersM = Users(
      uid: currentUserData["uid"] ?? "",
      name: currentUserData["name"] ?? "",
      keyName: currentUserData["keyName"] ?? "",
      email: currentUserData["email"] ?? "",
      photoUrl: currentUserData["photoUrl"] ?? "",
      status: currentUserData["status"] ?? "",
      creationTime: currentUserData["creationTime"] ?? "",
      lastSignInTime: currentUserData["lastSignInTime"] ?? "",
      updatedTime: currentUserData["updatedTime"] ?? "",
      // chats: currentUserData["chats"],
    );

    final chatsList =
        await users.doc(AppData.authData!.email).collection("chats").get();

    if (chatsList.docs.isNotEmpty) {
      List<ChatUser> chatListData = [];
      for (var element in chatsList.docs) {
        var chatDataDoc = element.data();
        var chatDataId = element.id;
        chatListData.add(
          ChatUser(
            chatId: chatDataId,
            connection: chatDataDoc["connection"],
            lastTime: chatDataDoc["lastTime"],
            totalUnread: chatDataDoc["total_unread"],
          ),
        );
      }

      usersM!.chatUser = chatListData;
    } else {
      usersM!.chatUser = [];
    }

    notifyListeners();
  }

  logout({Function(AuthState)? onSuccess, Function(String)? onError}) async {
    try {
      authState = AuthState.unauthenticating;
      onSuccess!(authState);
      notifyListeners();
      AppData.removePrefs();
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
        print("logout");
        authState = AuthState.unauthenticated;
        onSuccess(authState);
        notifyListeners();
      });
    } catch (e) {
      authState = AuthState.authenticated;
      debugPrint(e.toString());
      onError!(e.toString());
    }
    notifyListeners();
  }

  changeProfile(String name, String status,
      {Function()? onSuccess, Function()? onError}) async {
    try {
      loadingState = LoadingState.isWaiting;
      notifyListeners();
      CollectionReference users = firestore.collection(CollectionName.users);

      users.doc(_currentUser!.email).update({
        "name": name,
        "keyName": name.substring(0, 1).toUpperCase(),
        "status": status,
        "updatedTime": dateNow,
      });
      print("User Cred email : ${userCredential!.user!.email}");

      usersM!.name = name;
      usersM!.status = status;
      usersM!.updatedTime = dateNow;

      AppData.setUserPreferences(
        email: userCredential!.user!.email,
        name: name,
        photoUrl: userCredential!.user!.photoURL,
        status: status,
      );

      loadingState = LoadingState.isDone;
      onSuccess!();
    } catch (e) {
      loadingState = LoadingState.isDone;
      onError!();
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  addNewConnection(String friendEmail, {Function(String)? onSuccess}) async {
    bool flagNewConnection = false;
    String chatId = "";
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final usersDoc = await users.doc(AppData.authData!.email).get();
    final userChatDoc =
        (usersDoc.data() as Map<String, dynamic>)["chatUser"] as List;

    if (userChatDoc.isNotEmpty) {
      //? user mempunyai koneksi dengan user lain
      for (var element in userChatDoc) {
        //? memeriksa element koneksi yang sama dengan email user lain
        if (element["connection"] == friendEmail) {
          chatId = element["chat_id"];
        }
      }

      if (chatId != "") {
        //? user sudah memiliki koneksi dengan friend email
        flagNewConnection = false;
      } else {
        //? user belum memiliki koneksi dengan friend email
        flagNewConnection = true;
      }
    } else {
      //? user tidak memiliki koneksi sama sekali
      flagNewConnection = true;
    }

    if (flagNewConnection == true) {
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            AppData.authData!.email,
            friendEmail,
          ],
          [
            friendEmail,
            AppData.authData!.email,
          ]
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        //? chat terhubung
        final chatDataId = chatsDocs.docs[0].id;
        final chatData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        chatId = chatDataId;
        userChatDoc.add({
          "connection": friendEmail,
          "chat_id": chatId,
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });

        await users
            .doc(AppData.authData!.email)
            .update({"chatUser": userChatDoc});

        usersM!.chatUser = userChatDoc as List<ChatUser>;
      } else {
        //? buat koneksi baru berdua
        final newChatsDoc = await chats.add({
          "connections": [
            AppData.authData!.email,
            friendEmail,
          ],
          "chat": [],
        });

        chatId = newChatsDoc.id;

        userChatDoc.add({
          "connection": friendEmail,
          "chat_id": chatId,
          "lastTime": dateNow,
          "total_unread": 0,
        });

        await users
            .doc(AppData.authData!.email)
            .update({"chatUser": userChatDoc});

        usersM!.chatUser = userChatDoc as List<ChatUser>;
      }

      // if (chatsDocs.docs.isNotEmpty) {
      //   print("Ada Id Berdua");
      //   final chatsDataId = chatsDocs.docs[0].id;
      //   final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

      //   await users.doc(_currentUser!.email).update({
      //     "chats": [
      //       {
      //         "connection": friendEmail,
      //         "chat_id": chatsDataId,
      //         "lastTime": chatsData["lastTime"],
      //       }
      //     ]
      //   });
      //   usersM!.chats = [
      //     ChatUser(
      //       connection: friendEmail,
      //       chatId: chatsDataId,
      //       lastTime: chatsData["lastTime"],
      //       totalUnread: 0,
      //     )
      //   ];
      //   chatId = chatsDataId;
      //   notifyListeners();
      // } else {
      //   print("buat chat id baru");
      // }
    }

    onSuccess!(chatId);

    notifyListeners();
  }
}
