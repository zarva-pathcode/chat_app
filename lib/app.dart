import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/provider/chat_provider.dart';
import 'package:flutter_chat_app/logic/provider/search_provider.dart';
import 'package:flutter_chat_app/ui/screen/home_screen.dart';
import 'package:flutter_chat_app/ui/screen/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'logic/data/app_data.dart';
import 'logic/provider/auth_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      builder: (context, widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, ch) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ch!,
        ),
        home: AppData.authData == null
            ? const SignInScreen()
            : const HomeScreen(),
      ),
    );
  }
}
