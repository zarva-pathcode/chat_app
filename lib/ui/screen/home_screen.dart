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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            icon: const Icon(
              Icons.search_rounded,
            ),
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
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: Provider.of<ChatProvider>(context)
                .connectionStream(AppData.authData!.email!),
            builder: (context, snapshot1) {
              if (snapshot1.connectionState == ConnectionState.active) {
                var chatList = snapshot1.data!.docs;
                if (chatList.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidMessage,
                          color: Colors.grey[400],
                          size: 60,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Getting some friends",
                          style: AppText.mainTextStyle.copyWith(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: chatList.length,
                    itemBuilder: (context, i) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: Provider.of<ChatProvider>(context)
                            .friendStream(chatList[i]["connection"]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot2.data!.data();
                            return ConnectionChatTile(
                              image: data!["photoUrl"],
                              userName: data["name"],
                              unread: "${chatList[i]["total_unread"]}",
                              onTap: () {
                                print("ID ${chatList[i]["chat_id"]}");
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .goToChatRoom(
                                  chatId: chatList[i]["chat_id"],
                                  onSuccess: (chatID) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatId: chatList[i]["chat_id"],
                                        receiverEmail: chatList[i]
                                            ["connection"],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    },
                  ),
                );
              }
              return Column(
                children: [
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Loading.. please wait",
                    style: AppText.mainTextStyle
                        .copyWith(color: Colors.grey[400], fontSize: 18),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
