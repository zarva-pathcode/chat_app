import 'package:flutter/material.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String image;
  final Function()? onTap;
  const SearchTile({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            image == ""
                ? const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile.png"),
                    radius: 20,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    backgroundColor: Colors.blueGrey,
                    radius: 20,
                  ),
            const SizedBox(
              width: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppText.mainTextStyle.copyWith(fontSize: 15),
                ),
                Text(
                  userEmail,
                  style: AppText.mainTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Text(
                  "Message",
                  style: AppText.mainTextStyle.copyWith(
                    fontSize: 11,
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
