// ignore_for_file: deprecated_member_use

import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_club/pages/profile_page.dart';
import 'package:sports_club/utils/colors.dart';

import '../helpers/utils.dart';
import '../resources/storage_methods.dart';
import '../utils/utils.dart';

class editPorfilePage extends StatefulWidget {
  final userUrl;
  final userName;
  final userAbout;

  const editPorfilePage(
      {Key? key,
      required this.userUrl,
      required this.userName,
      required this.userAbout})
      : super(key: key);

  @override
  State<editPorfilePage> createState() => _editPorfilePageState();
}

class _editPorfilePageState extends State<editPorfilePage> {
  bool isEdit = false;
  Uint8List? image;
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _userAboutController = TextEditingController();
  bool isSaving = false;

  // late String photoUrl;

  //pick image from gallery
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // photoUrl = await StorageMethods().uploadImageToStorage('PorfilePics', im, false);
    setState(() {
      image = im;
    });
  }

  Future editProfile() async {
    setState(() {
      isSaving = true;
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'username': _usernameController.text,
      'bio': _userAboutController.text
    });
    setState(() {
      isSaving = false;
    });
    Navigator.pop(context,3);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userAboutController = TextEditingController(text: widget.userAbout);
    _usernameController = TextEditingController(text: widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("編輯個人頁面"),
        backgroundColor: appbarColor,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Center(
                  child: image == null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            widget.userUrl,
                          ),
                          radius: 60,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: MemoryImage(image!),
                          radius: 60,
                        ),
                ),
                Positioned(
                  top: 83,
                  left: 215,
                  child: InkWell(
                    onTap: selectImage,
                    child: buildEditIcon(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _userAboutController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 5,
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 40,
              child: RaisedButton(
                color: appbarColor,
                onPressed: editProfile,
                child: isSaving
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Save", style: TextStyle(color: Colors.white,fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
      buildCircle(const Icon(Icons.edit),appbarColor, 3), color, 3);

  Widget buildCircle(Widget child, Color color, double all) => ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
