import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:flutter_chat_app/logic/data/model/users.dart';
import 'package:flutter_chat_app/logic/provider/chat_provider.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/widgets/chat_item.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String? receiverEmail;

  const ChatScreen({
    Key? key,
    this.chatId,
    this.receiverEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  final TextEditingController textC = TextEditingController();
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    print("CHAT ID : ${widget.chatId}");
    print("EMAIL : ${widget.receiverEmail}");
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    textC.dispose();
    scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: Provider.of<ChatProvider>(context)
                .friendStream(widget.receiverEmail!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> map = snapshot.data!.data()!;
                Users data = Users.fromJson(map);
                return Row(
                  children: [
                    data.photoUrl == ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              "assets/images/profile.png",
                              fit: BoxFit.cover,
                              height: 38,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              data.photoUrl!,
                              fit: BoxFit.cover,
                              height: 38,
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name!,
                          style: AppText.mainTextStyle
                              .copyWith(color: Colors.white, fontSize: 17),
                        ),
                        Text(
                          data.status == "" ? "No Status" : data.status!,
                          style: AppText.mainTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    )
                  ],
                );
              }
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      "assets/images/profile.png",
                      height: 36,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: AppText.mainTextStyle
                            .copyWith(color: Colors.white, fontSize: 17),
                      ),
                      Text(
                        "status",
                        style: AppText.mainTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  )
                ],
              );
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: Provider.of<ChatProvider>(context)
                    .chatStream(widget.chatId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var chatData = snapshot.data!.docs;

                    Timer(
                        Duration.zero,
                        () => scrollController!.jumpTo(
                            scrollController!.position.maxScrollExtent));
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: chatData.length,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${chatData[i]["timeGroup"]}",
                                style: AppText.mainTextStyle
                                    .copyWith(color: Colors.grey),
                              ),
                              ChatItem(
                                isSender: chatData[i]["sender"] ==
                                        AppData.authData!.email
                                    ? true
                                    : false,
                                msg: "${chatData[i]["message"]}",
                                time: "${chatData[i]["time"]}",
                              ),
                            ],
                          );
                        }
                        if (chatData[i]["timeGroup"] ==
                            chatData[i - 1]["timeGroup"]) {
                          return ChatItem(
                            isSender:
                                chatData[i]["sender"] == AppData.authData!.email
                                    ? true
                                    : false,
                            msg: "${chatData[i]["message"]}",
                            time: "${chatData[i]["time"]}",
                          );
                        }
                        return Column(
                          children: [
                            Text(
                              "${chatData[i]["timeGroup"]}",
                              style: AppText.mainTextStyle
                                  .copyWith(color: Colors.grey),
                            ),
                            ChatItem(
                              isSender: chatData[i]["sender"] ==
                                      AppData.authData!.email
                                  ? true
                                  : false,
                              msg: "${chatData[i]["message"]}",
                              time: "${chatData[i]["time"]}",
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.blueGrey.withOpacity(.1)),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            style: AppText.mainTextStyle.copyWith(fontSize: 18),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14)
                                  .copyWith(right: 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.grey[400],
                                ),
                              ),
                              hintStyle: AppText.mainTextStyle.copyWith(
                                color: Colors.grey[400],
                              ),
                              hintText: "Type your message here ....",
                            ),
                            controller: textC,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Provider.of<ChatProvider>(context, listen: false).newChat(
                        widget.chatId!,
                        textC.text,
                        widget.receiverEmail!,
                        chatAdded: () => scrollController!
                            .jumpTo(scrollController!.position.maxScrollExtent),
                      );
                      textC.clear();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.height / 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[800],
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
