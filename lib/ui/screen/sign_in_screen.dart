import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';

import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/screen/home_screen.dart';
import 'package:flutter_chat_app/ui/widgets/state_dialog.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).loginWithGoogle(
                state: (authState) {
                  if (authState == AuthState.authenticating) {
                    showDialog(
                      context: context,
                      builder: (context) => const StateDialog(
                        text: "Authenticating.. please wait",
                      ),
                    );
                  } else if (authState == AuthState.unauthenticated) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => const StateDialog(
                        isLoading: false,
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
                        isLoading: false,
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
        ],
      ),
    );
  }
}
