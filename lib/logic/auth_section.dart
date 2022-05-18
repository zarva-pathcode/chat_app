import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/data/app_data.dart';
import 'package:flutter_chat_app/ui/screen/sign_in_screen.dart';
import 'package:flutter_chat_app/ui/screen/home_screen.dart';

class AuthSection extends StatefulWidget {
  const AuthSection({Key? key}) : super(key: key);

  @override
  State<AuthSection> createState() => _AuthSectionState();
}

class _AuthSectionState extends State<AuthSection> {
  var authData;

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    authData = await AppData.getUserPreferences();
  }

  @override
  Widget build(BuildContext context) {
    if (authData == null) {
      return const SignInScreen();
    }
    return const HomeScreen();
  }
}
