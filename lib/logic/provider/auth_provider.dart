import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:flutter_chat_app/logic/data/model/users.dart';
import 'package:flutter_chat_app/ui/helper/collection_ref.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

enum StateInfo {
  isLoading,
  isDone,
}

enum AuthState {
  authenticating,
  authenticated,
  unauthenticating,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? dateNow = DateTime.now().toIso8601String();
  FirebaseStorage storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthState authState = AuthState.unauthenticated;
  final ImagePicker _imagePicker = ImagePicker();
  StateInfo stateInfo = StateInfo.isDone;
  GoogleSignInAuthentication? _authUser;
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  Users? usersM = Users();
  XFile? pickedImage;

  Future<void> loginWithGoogle({
    Function(AuthState)? state,
    Function(String)? onError,
  }) async {
    try {
      authState = AuthState.authenticating;
      state!(authState);
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
        state(authState);
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
          "updatedTime": dateNow,
        });

        users.doc(_currentUser!.email).collection("chatUser");

        AppData.setUserPreferences(
          email: userCredential!.user!.email,
          name: userCredential!.user!.displayName,
          photoUrl: userCredential!.user!.photoURL ?? "",
          status: "",
        );

        authState = AuthState.unauthenticated;
        state(authState);
        notifyListeners();
      }
    } catch (e) {
      stateInfo = StateInfo.isDone;
      debugPrint(e.toString());
      // onError!(e.toString());
    }
    notifyListeners();
  }

  getProfile() async {
    CollectionReference users = firestore.collection('users');
    final currentUser = await users.doc(AppData.authData!.email).get();
    final currentUserData = currentUser.data() as Map<String, dynamic>;
    print("UserData : $currentUserData");
    usersM = Users.fromJson(currentUserData);

    final chatsList =
        await users.doc(AppData.authData!.email).collection("chatUser").get();

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
      await _googleSignIn.disconnect().then((_) {
        print("Disconnected");
      }).catchError((error) {
        print("Some error is coming when disconnect");
        onError!(error);
      });
      await _googleSignIn.signOut().then((_) {
        print("Signout Success");
      }).catchError((error) {
        print("Some error is coming when signOut");
        onError!(error);
      });

      AppData.removePrefs();
      Future.delayed(const Duration(seconds: 2)).then((_) async {
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
      {Function(StateInfo)? state, Function()? onError}) async {
    try {
      stateInfo = StateInfo.isLoading;
      notifyListeners();
      CollectionReference users = firestore.collection(CollectionName.users);

      users.doc(AppData.authData!.email).update({
        "name": name,
        "keyName": name.substring(0, 1).toUpperCase(),
        "status": status,
        "updatedTime": dateNow,
      });

      usersM!.name = name;
      usersM!.status = status;
      usersM!.updatedTime = dateNow;

      AppData.setUserPreferences(
        email: AppData.authData!.email,
        name: name,
        photoUrl: AppData.authData!.photoUrl,
        status: status,
      );

      stateInfo = StateInfo.isDone;
      state!(stateInfo);
    } catch (e) {
      stateInfo = StateInfo.isDone;
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

    final usersChatDoc =
        await users.doc(AppData.authData!.email).collection("chatUser").get();

    if (usersChatDoc.docs.isNotEmpty) {
      //? user mempunyai koneksi dengan user lain

      //? cari data, apakah user sekarang punya koneksi dengan friendEmail
      final checkConnection = await users
          .doc(AppData.authData!.email)
          .collection("chatUser")
          .where(
            "connection",
            isEqualTo: friendEmail,
          )
          .get();

      if (checkConnection.docs.isNotEmpty) {
        //? user sudah memiliki koneksi dengan friend email
        flagNewConnection = false;
        chatId = checkConnection.docs[0].id;
      } else {
        //? user belum memiliki koneksi dengan friend email
        flagNewConnection = true;
      }
    } else {
      //? user tidak memiliki koneksi sama sekali
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      //? cek data di chats collection, apakah ada yang memiliki koneksi satu sama lain
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

        await users
            .doc(AppData.authData!.email)
            .collection("chatUser")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "chat_id": chatId,
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });
      } else {
        //? buat koneksi baru berdua
        final newChatsDoc = await chats.add({
          "connections": [
            AppData.authData!.email,
            friendEmail,
          ],
        });

        chatId = newChatsDoc.id;

        chats.doc(chatId).collection("chat");

        await users
            .doc(AppData.authData!.email)
            .collection("chatUser")
            .doc(chatId)
            .set({
          "connection": friendEmail,
          "chat_id": chatId,
          "lastTime": dateNow,
          "total_unread": 0,
        });
      }
    }

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

    onSuccess!(chatId);

    notifyListeners();
  }

  void selectImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    pickedImage = image;
    notifyListeners();
  }

  void resetImage() {
    pickedImage = null;
    notifyListeners();
  }

  Future uploadImage(String uid, {Function()? onSuccess}) async {
    Reference storageRef = storage.ref("$uid.png");
    File file =
        await FlutterNativeImage.compressImage(pickedImage!.path, quality: 50);
    try {
      await storageRef.putFile(file);
      final photoUrl = await storageRef.getDownloadURL();
      resetImage();
      CollectionReference users = firestore.collection('users');
      if (photoUrl != "") {
        await users.doc(AppData.authData!.email).update({
          "photoUrl": photoUrl,
          "updatedTime": dateNow,
        });

        usersM!.photoUrl = photoUrl;
        usersM!.updatedTime = dateNow;

        AppData.setUserPreferences(
          email: AppData.authData!.email,
          name: AppData.authData!.name,
          photoUrl: photoUrl,
          status: AppData.authData!.status,
        );
      }
      onSuccess!();
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
