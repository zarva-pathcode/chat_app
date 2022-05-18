import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';

class ConnectionChatTile extends StatelessWidget {
  final String userName;
  final String highlightText;
  final String unread;
  final Function()? onTap;
  const ConnectionChatTile(
      {Key? key,
      required this.userName,
      required this.highlightText,
      this.onTap,
      required this.unread})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              backgroundImage: AssetImage("assets/images/profile.png"),
              radius: 24,
            ),
            const SizedBox(
              width: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppText.mainTextStyle
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  highlightText,
                  style: AppText.mainTextStyle.copyWith(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            const Spacer(),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[300]!,
              ),
              child: Center(
                child: Text(
                  unread,
                  style: AppText.mainTextStyle.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
