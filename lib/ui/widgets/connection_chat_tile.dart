import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';

class ConnectionChatTile extends StatelessWidget {
  final String image;
  final String userName;
  final String unread;
  final Function()? onTap;
  const ConnectionChatTile(
      {Key? key,
      required this.userName,
      this.onTap,
      required this.unread,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              backgroundImage: image == ""
                  ? const AssetImage("assets/images/profile.png")
                      as ImageProvider
                  : NetworkImage(image),
              radius: 24,
            ),
            const SizedBox(
              width: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: AppText.mainTextStyle
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 6,
                ),
                unread != "0"
                    ? Text(
                        "Pesan Belum Terbaca",
                        style: AppText.mainTextStyle.copyWith(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300),
                      )
                    : const SizedBox()
              ],
            ),
            const Spacer(),
            unread == "0"
                ? const SizedBox()
                : Container(
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
