import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/helper/dailogs.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 34, 33, 33),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 1,
            title: Text(
              "Profile Screen",
              style: GoogleFonts.pacifico(
                // Change the font here
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
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
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .05,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image,
                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: -4,
                          right: -3,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: CircleBorder(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffC33764),
                                    Color(0xff1D2671)
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(Iconsax.edit,
                                    color: Colors.white, size: 17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 231, 230, 230),
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.user,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 241, 37, 132)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 241, 37, 132)
                                  .withOpacity(.5)),
                        ),
                        hintText: 'Enter your Name',
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.info_circle,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 241, 37, 132)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 241, 37, 132)
                                  .withOpacity(.5)),
                        ),
                        hintText: 'Enter your About',
                        labelText: 'About',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xffC33764), // Start color (purple)
                            Color(0xff1D2671), // End color (pink)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, '🎉 Profile Updated Successfully!');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.transparent, // Set transparent background
                          onPrimary: Colors
                              .transparent, // Set transparent onPrimary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.edit_25,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xffC33764), // Start color (purple)
                            Color(0xff1D2671), // End color (pink)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 34, 33, 33),
                                title: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  "Are you sure you want to logout?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the alert dialog
                                    },
                                    child: Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Dialogs.showProgressBar(context);
                                      await APIs.updateActiveStatus(false);
                                      await APIs.auth
                                          .signOut()
                                          .then((value) async {
                                        await GoogleSignIn()
                                            .signOut()
                                            .then((value) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          APIs.auth = FirebaseAuth.instance;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      LoginScreen()));
                                        });
                                      });
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          onPrimary: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.logout,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  // Change the font here
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(135, 81, 81, 81),
                        shape: CircleBorder(),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.15)),
                    onPressed: () {
                      _pickImageFromGallery(context);
                    },
                    child: Image.asset('images/gallery.png'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(135, 81, 81, 81),
                        shape: CircleBorder(),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.15)),
                    onPressed: () {
                      _pickImageFromCamera(context);
                    },
                    child: Image.asset('images/camera.png'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      // You can use the picked image here, for example, display it in an Image widget.
      // For demonstration purposes, we'll print the image path.
      print("Image path: ${pickedFile.path}");
      setState(() {
        _image = pickedFile.path;
      });
      APIs.updateProfilePicture(File(_image!));
      Navigator.pop(context);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedFile != null) {
      // You can use the picked image here, for example, display it in an Image widget.
      // For demonstration purposes, we'll print the image path.
      print("Image path: ${pickedFile.path}");
      setState(() {
        _image = pickedFile.path;
      });
      APIs.updateProfilePicture(File(_image!));

      Navigator.pop(context);
    } else {
      print('No image selected.');
    }
  }
}
