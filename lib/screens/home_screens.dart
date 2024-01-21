import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/helper/dailogs.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/screens/profile_screen.dart';
import 'package:chattingapp/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 34, 33, 33),
            appBar: AppBar(
              centerTitle: true,
              elevation: 1,
              leading: Icon(
                Iconsax.home,
                color: Colors.white,
              ),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name, Email, ..."),
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.5),
                      onChanged: (val) {
                        _searchList.clear();

                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    )
                  : Text(
                      "Pico Chat",
                      style: GoogleFonts.pacifico(
                        // Change the font here
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                      _isSearching ? Icons.cancel : Iconsax.search_normal,
                      color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffC33764),
                      Color(0xff1D2671),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () async {
                  _AddChatUserDailog();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffC33764),
                        Color(0xff1D2671),
                      ], // Specify your gradient colors
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Adjust padding as needed
                    child: Icon(Iconsax.add,
                        color: Colors.white), // Set the icon color
                  ),
                ),
              ),
            ),
            body: StreamBuilder(
            stream: APIs.getMyUserId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllUser(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Connections Found!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _AddChatUserDailog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 32, 32, 32),
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Iconsax.user_add,
                    color: Color.fromARGB(255, 241, 37, 132),
                    size: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Add User',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 241, 37, 132),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 241, 37, 132)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 241, 37, 132),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Color.fromARGB(255, 241, 37, 132),
                          fontSize: 16),
                    )),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty)
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, "User does not Exists!");
                          }
                        });
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Color.fromARGB(255, 241, 37, 132),
                          fontSize: 16),
                    ))
              ],
            ));
  }
}
