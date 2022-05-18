import 'package:flutter/material.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';

class StateDialog extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Widget? icon;
  const StateDialog({
    Key? key,
    required this.text,
    this.isLoading = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 10,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading ? const CircularProgressIndicator() : icon!,
              const SizedBox(
                height: 8,
              ),
              Text(
                text,
                style: AppText.mainTextStyle
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
