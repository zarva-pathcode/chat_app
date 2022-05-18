import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';
import 'package:flutter_chat_app/logic/provider/chat_provider.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/helper/const_color.dart';
import 'package:flutter_chat_app/ui/screen/chat_screen.dart';
import 'package:flutter_chat_app/ui/screen/profile_screen.dart';
import 'package:flutter_chat_app/ui/screen/search_screen.dart';
import 'package:flutter_chat_app/ui/widgets/connection_chat_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Provider.of<AuthProvider>(context, listen: false).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "ChatsApp",
          style: AppText.mainTextStyle.copyWith(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Profile",
                  style: AppText.mainTextStyle,
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  "Settings",
                  style: AppText.mainTextStyle,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: Provider.of<ChatProvider>(context)
                  .chatStream(AppData.authData!.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  if (!snapshot1.hasData) {
                    return const Center(
                      child: SizedBox(),
                    );
                  }
                  var chatList = (snapshot1.data!.data()
                      as Map<String, dynamic>)["chatUser"] as List;
                  return ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, i) {
                      if (chatList.isEmpty) {
                        return const SizedBox();
                      }
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: Provider.of<ChatProvider>(context)
                            .friendStream(chatList[i]["connection"]!),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Getting friends.. please wait",
                                    style: AppText.mainTextStyle
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            );
                          }
                          var friendData = snapshot2.data!.data();
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChatScreen(),
                                ),
                              );
                            },
                            child: ConnectionChatTile(
                              userName: friendData!["name"],
                              highlightText: "Test user broooo",
                              unread: chatList[i]["total_unread"].toString(),
                              onTap: () {},
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
