import 'package:flutter/material.dart';

import 'package:flutter_chat_app/logic/data/model/users.dart';
import 'package:flutter_chat_app/logic/data/model/auth_data.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/widgets/main_dialog.dart';
import 'package:flutter_chat_app/ui/widgets/main_textfield.dart';
import 'package:provider/provider.dart';

class ChangeProfileScreen extends StatefulWidget {
  final Users? usersM;
  const ChangeProfileScreen({
    Key? key,
    this.usersM,
  }) : super(key: key);

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  TextEditingController? nameC;
  TextEditingController? statusC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
  }

  setUp() {
    nameC = TextEditingController(text: widget.usersM!.name);
    statusC = TextEditingController(text: widget.usersM!.status);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Profile",
          style: AppText.mainTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 14,
                ),
                MainTextField(
                  controller: nameC,
                  label: "Name",
                ),
                const SizedBox(
                  height: 14,
                ),
                MainTextField(
                  controller: statusC,
                  label: "Status",
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false)
                        .changeProfile(
                      nameC!.text,
                      statusC!.text,
                      onSuccess: () {
                        FocusScope.of(context).unfocus();
                        showDialog(
                            context: context,
                            builder: (context) => const MainDialog(
                                  text: "Your Profile has been changed",
                                ));
                      },
                      onError: () => showDialog(
                        context: context,
                        builder: (context) => const MainDialog(
                          text: "Your Profile failed to changed",
                          isFail: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[800],
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: AppText.mainTextStyle
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
