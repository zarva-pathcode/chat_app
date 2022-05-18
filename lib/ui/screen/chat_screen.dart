import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;

  const ChatScreen({
    Key? key,
    this.chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatScreen> {
  final TextEditingController textC = TextEditingController();
  DateFormat? dt;
  // final List<Message> _textList = [
  //   Message(time: "02.01", text: "Hello!", selfSender: false),
  //   Message(time: "02.02", text: "This is Flutter Chat App", selfSender: false),
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
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
                  "online",
                  style: AppText.mainTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                itemCount: 0,
                itemBuilder: (context, i) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 52,
                    minWidth: 70,
                  ),
                  child: Align(
                    // alignment: _textList[i].selfSender
                    //     ? Alignment.centerRight
                    //     : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 14),
                      child: Column(
                        // crossAxisAlignment: _textList[i].selfSender
                        //     ? CrossAxisAlignment.end
                        //     : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: _textList[i].selfSender
                              //     ? const BorderRadius.only(
                              //         topRight: Radius.circular(20),
                              //       )
                              //     : const BorderRadius.only(
                              //         topLeft: Radius.circular(
                              //           20,
                              //         ),
                              //       ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(4, 8),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(.12),
                                )
                              ],
                            ),
                            // child: Text(
                            //   _textList[i].text,
                            //   style:
                            //       AppText.mainTextStyle.copyWith(fontSize: 15),
                            // ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Text(
                          //   _textList[i].time,
                          //   style: AppText.mainTextStyle.copyWith(
                          //     color: Colors.grey,
                          //     fontSize: 13,
                          //     fontWeight: FontWeight.w300,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      if (textC.text == "") {
                        return;
                      }
                      setState(() {
                        var date = DateFormat("hh:mm").format(DateTime.now());

                        // _textList.add(
                        //   Message(
                        //     time: date,
                        //     text: textC.text,
                        //     selfSender: true,
                        //   ),
                        // );
                        // textC.clear();
                      });
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
