import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/helper/my_date_util.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message_user.dart';
import 'package:chattingapp/screens/call_screen.dart';
import 'package:chattingapp/screens/view_profile_screen.dart';
import 'package:chattingapp/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 34, 33, 33),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              backgroundColor:
                  Colors.transparent, // Set the background color to transparent
              elevation: 0, // Remove the shadow
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return Container(
                              child: Center(
                                  child: Lottie.asset('images/hello.json',
                                      width: 250, height: 250)),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Color.fromARGB(255, 34, 33, 33),
                        indicatorColor: Color.fromARGB(255, 241, 37, 132),
                        iconColor: Colors.grey,
                        iconColorSelected: Color.fromARGB(255, 241, 37, 132),
                        skinToneDialogBgColor: Color.fromARGB(255, 39, 37, 37),
                        skinToneIndicatorColor:
                            Color.fromARGB(255, 241, 37, 132),
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
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

  Widget _appBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffC33764), Color(0xff1D2671)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)),
    );
  },
  child: StreamBuilder(
    stream: APIs.getUserInfo(widget.user),
    builder: (context, snapshot) {
      final data = snapshot.data?.docs;
      final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
      return Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                list.isNotEmpty ? list[0].name : widget.user.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                list.isNotEmpty
                    ? list[0].isOnline
                        ? 'Online'
                        : MyDateUtils.getLastActiveTime(
                            context: context,
                            lastActive: list[0].lastActive,
                          )
                    : MyDateUtils.getLastActiveTime(
                        context: context,
                        lastActive: widget.user.lastActive,
                      ),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(), // Adds space to push the buttons to the right
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen()));
            },
            icon: Icon(
              Iconsax.call,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle video call button press
            },
            icon: Icon(
              Iconsax.video,
              color: Colors.white,
            ),
          ),
        ],
      );
    },
  ),
),

    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color.fromARGB(135, 81, 81, 81),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Color.fromARGB(255, 241, 37, 132),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type Something ...",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 213, 213, 213)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        setState(() {
                          _isUploading = true;
                        });
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          _isUploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Iconsax.image,
                      color: Color.fromARGB(255, 241, 37, 132),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        print('Image Path: ${image.path}');
                        setState(() {
                          _isUploading = true;
                        });
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() {
                          _isUploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Iconsax.camera,
                      color: Color.fromARGB(255, 241, 37, 132),
                    ),
                  ),
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffC33764),
                  Color(0xff1D2671)
                ], // Adjust colors as needed
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              shape: BoxShape.circle,
            ),
            child: MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  if(_list.isEmpty){
                    APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                  }else{
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                  }
                  _textController.text = '';
                }
              },
              minWidth: 0,
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
