import 'package:flutter/material.dart';
import 'package:flutter_chat_app/logic/provider/auth_provider.dart';
import 'package:flutter_chat_app/logic/provider/search_provider.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';
import 'package:flutter_chat_app/ui/helper/const_color.dart';
import 'package:flutter_chat_app/ui/screen/chat_screen.dart';
import 'package:flutter_chat_app/ui/widgets/search_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchC.clear();
  }

  @override
  Widget build(BuildContext context) {
    var searchProv = Provider.of<SearchProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Search Users",
          style: AppText.mainTextStyle.copyWith(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: searchC,
                      style: AppText.mainTextStyle
                          .copyWith(color: Colors.grey, fontSize: 18),
                      decoration: InputDecoration(
                        hintStyle: AppText.mainTextStyle
                            .copyWith(color: Colors.grey[400]),
                        hintText: "Search here ...",
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.white,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: searchProv.searchFriends),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.blue[400], shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<SearchProvider>(builder: (context, data, ch) {
            return data.searchList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 200,
                        ),
                        FaIcon(
                          FontAwesomeIcons.search,
                          color: Colors.grey[300],
                          size: 70,
                        ),
                        Text(
                          "Search Friends",
                          style: AppText.mainTextStyle
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : data.isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : data.friendsList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 200,
                              ),
                              FaIcon(
                                FontAwesomeIcons.exclamation,
                                color: Colors.grey[300],
                                size: 70,
                              ),
                              Text(
                                "Tidak ditemukan",
                                style: AppText.mainTextStyle
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: data.friendsList.length,
                              itemBuilder: (context, i) {
                                var friend = data.friendsList[i];
                                return SearchTile(
                                  image: friend["photoUrl"],
                                  userName: friend["name"],
                                  userEmail: friend["email"],
                                  onTap: () {
                                    print("user Tapped");
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .addNewConnection(
                                      friend["email"],
                                      onSuccess: (chatId) {
                                        print("This is the chat id : $chatId");
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          );
          }),
        ],
      ),
    );
  }
}
