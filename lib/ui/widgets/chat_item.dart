import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSender ? Colors.blue[800] : Colors.blueGrey,
              borderRadius: isSender
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              msg,
              style: AppText.mainTextStyle
                  .copyWith(color: Colors.white, fontSize: 15),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat.jm().format(
              DateTime.parse(time),
            ),
            style: AppText.mainTextStyle
                .copyWith(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
