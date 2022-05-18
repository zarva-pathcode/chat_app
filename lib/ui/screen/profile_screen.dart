import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/screen/change_profile_screen.dart';
import 'package:flutter_chat_app/ui/screen/sign_in_screen.dart';
import 'package:flutter_chat_app/ui/widgets/state_dialog.dart';
import 'package:flutter_chat_app/ui/widgets/profile_list_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: AppText.mainTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Consumer<AuthProvider>(builder: (context, data, ch) {
        if (data.loadingState == LoadingState.isWaiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
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
                  child: data.usersM!.photoUrl == null
                      ? Image.asset("assets/images/profile.png")
                      : Image.network(
                          data.usersM!.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              data.usersM!.name ?? "Username",
              style: AppText.mainTextStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              data.usersM!.email ?? "Email",
              style: AppText.mainTextStyle.copyWith(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 30,
            ),
            ProfileListTile(
              onTap: () {},
              label: "Update Status",
              icon: FontAwesomeIcons.file,
            ),
            ProfileListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeProfileScreen(
                      usersM: data.usersM,
                    ),
                  ),
                );
              },
              label: "Change Profile",
              icon: Icons.person_outlined,
            ),
            const ProfileListTile(
              label: "Change Theme",
              icon: FontAwesomeIcons.palette,
            ),
            const Spacer(),
            ProfileListTile(
              isLogout: true,
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout(
                    onSuccess: (authState) {
                  if (authState == AuthState.unauthenticating) {
                    showDialog(
                      context: context,
                      builder: (context) => const StateDialog(
                        text: "Logging out.. please wait",
                      ),
                    );
                  } else if (authState == AuthState.unauthenticated) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => const StateDialog(
                        isLoading: false,
                        text: "Logout Successfuly",
                        icon: Icon(
                          Icons.check_circle,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                    );
                    Future.delayed(
                      const Duration(seconds: 2),
                    ).then(
                      (_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }),
    );
  }
}
