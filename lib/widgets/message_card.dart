import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/helper/dailogs.dart';
import 'package:chattingapp/helper/my_date_util.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/message_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:iconsax/iconsax.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blackMessage(),
    );
  }

  Widget _blackMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print("message read Updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(135, 81, 81, 81),
                border: Border.all(color: Color(0xffC33764)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Iconsax.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtils.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: TextStyle(fontSize: 13, color: Colors.white60),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Color(0xffC33764),
                size: 20,
              ),
            SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtils.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.white60),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.01,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffC33764), Color(0xff1D2671)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Color(0xffC33764)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Iconsax.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Iconsax.copy,
                        color: Color.fromARGB(255, 241, 37, 132),
                        size: 26,
                      ),
                      name: "Copy Text",
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Text Copied');
                        });
                      })
                  : _OptionItem(
                      icon: Icon(
                        Iconsax.save_2,
                        color: Color.fromARGB(255, 241, 37, 132),
                        size: 26,
                      ),
                      name: "Save Image",
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'Pico Chat')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, "Image Successfully Saved:");
                            }
                          });
                        } catch (e) {
                          print("Errorrrrr $e");
                        }
                      }),
              if (isMe)
                Divider(
                  color: Colors.grey,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: Icon(
                      Iconsax.edit,
                      color: Colors.green,
                      size: 26,
                    ),
                    name: "Edit Message",
                    onTap: () {
                      Navigator.pop(context);
                      _showMessageUpdateDialog();
                    }),
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Iconsax.trash,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: "Delete Message",
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, 'Message was deleted');
                      });
                    }),
              Divider(
                color: Colors.grey,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              _OptionItem(
                  icon: Icon(
                    Iconsax.send,
                    color: Color.fromARGB(255, 241, 37, 132),
                    size: 26,
                  ),
                  name:
                      "Sent At: ${MyDateUtils.getMessageTime(context: context, time: widget.message.sent)}",
                  onTap: () {}),
              _OptionItem(
                  icon: Icon(
                    Iconsax.repeat,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: widget.message.read.isEmpty
                      ? "Read At: Not seen yet"
                      : "Read At: ${MyDateUtils.getMessageTime(context: context, time: widget.message.read)}",
                  onTap: () {})
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

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
                    Iconsax.message,
                    color: Color.fromARGB(255, 241, 37, 132),
                    size: 28,
                  ),
                  Text(
                    ' Update Message',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 241, 37, 132)), 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Colors.white), 
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

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                          color: Color.fromARGB(255, 241, 37, 132),
                          fontSize: 16),
                    ))
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: TextStyle(
                  fontSize: 15, color: Colors.white, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
