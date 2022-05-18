import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileListTile extends StatelessWidget {
  final Function()? onTap;
  final IconData? icon;
  final String? label;
  final bool isLogout;
  const ProfileListTile(
      {Key? key, this.icon, this.label, this.onTap, this.isLogout = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FaIcon(
                  isLogout ? FontAwesomeIcons.exclamation : icon!,
                  color: isLogout ? Colors.red : Colors.grey,
                  size: 18,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  isLogout ? "Logout" : label!,
                  style: AppText.mainTextStyle.copyWith(
                    color: isLogout ? Colors.red : Colors.grey,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            FaIcon(
              isLogout ? Icons.exit_to_app : FontAwesomeIcons.arrowRight,
              color: isLogout ? Colors.red : Colors.grey,
              size: isLogout ? 24 : 16,
            )
          ],
        ),
      ),
    );
  }
}
