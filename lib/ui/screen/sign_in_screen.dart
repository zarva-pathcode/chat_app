import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/screen/home_screen.dart';
import 'package:flutter_chat_app/ui/widgets/state_dialog.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: AppText.mainTextStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            InkWell(
              onTap: () {
                _auth.loginWithGoogle(
                  stateInfo: (authState) {
                    if (authState == AuthState.authenticating) {
                      showDialog(
                          context: context,
                          builder: (context) => const StateDialog(
                              text: "Authenticating.. please wait"));
                    } else if (authState == AuthState.unauthenticated) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => const StateDialog(
                          text: "Regitered Successfully",
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 2)).then((_) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false));
                    } else if (authState == AuthState.authenticated) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => const StateDialog(
                          text: "Login Successfully",
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 2)).then((_) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false));
                    }
                  },
                  onError: (e) {
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "Sign In with Google",
                    style: AppText.mainTextStyle.copyWith(
                        color: Colors.blue[700], fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
