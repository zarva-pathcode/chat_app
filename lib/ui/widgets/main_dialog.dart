import 'package:flutter/material.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';

class MainDialog extends StatelessWidget {
  final bool isFail;
  final String? text;
  final bool isLoading;
  const MainDialog({
    Key? key,
    this.isFail = false,
    this.isLoading = false,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        height: 160,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Loading ...",
                    style: AppText.mainTextStyle.copyWith(
                      color: Colors.grey[400],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      isFail ? "Failed" : "Success",
                      style: AppText.mainTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: Text(
                      text!,
                      style: AppText.mainTextStyle
                          .copyWith(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "Oke",
                            style: AppText.mainTextStyle.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
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
