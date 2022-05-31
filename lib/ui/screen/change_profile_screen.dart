import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_chat_app/logic/data/model/users.dart';
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
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 14,
                ),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: widget.usersM!.photoUrl == null
                          ? Image.asset("assets/images/profile.png")
                          : Image.network(
                              widget.usersM!.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                Consumer<AuthProvider>(
                  builder: (context, data, ch) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: data.pickedImage == null
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: data.pickedImage == null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            data.pickedImage == null
                                ? Text(
                                    "No Image",
                                    style: AppText.mainTextStyle,
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          File(data.pickedImage!.path),
                                        ),
                                      ),
                                    ),
                                  ),
                            data.pickedImage == null
                                ? TextButton(
                                    onPressed: () => authProvider.selectImage(),
                                    child: Text(
                                      "Choose Image",
                                      style: AppText.mainTextStyle
                                          .copyWith(color: Colors.blue),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        data.pickedImage == null
                            ? const SizedBox()
                            : const SizedBox(
                                height: 10,
                              ),
                        data.pickedImage == null
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => authProvider.resetImage(),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  OutlinedButton(
                                    onPressed: () => authProvider.uploadImage(
                                      widget.usersM!.uid!,
                                      onSuccess: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const MainDialog(
                                            isLoading: false,
                                            text: "Image Uploaded",
                                          ),
                                        );
                                      },
                                    ),
                                    child: Text(
                                      "Upload Image",
                                      style: AppText.mainTextStyle
                                          .copyWith(color: Colors.blue),
                                    ),
                                  )
                                ],
                              )
                      ],
                    );
                  },
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
                      state: (stateInfo) {
                        FocusScope.of(context).unfocus();
                        if (stateInfo == StateInfo.isLoading) {
                          showDialog(
                            context: context,
                            builder: (context) => const MainDialog(
                              isLoading: true,
                            ),
                          );
                        }
                        if (stateInfo == StateInfo.isDone) {
                          showDialog(
                            context: context,
                            builder: (context) => const MainDialog(
                              text:
                                  "Your Profile has been updated Successfully",
                            ),
                          );
                        }
                      },
                      onError: () {
                        FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (context) => const MainDialog(
                            text: "Your Profile failed to changed",
                            isFail: true,
                          ),
                        );
                      },
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
