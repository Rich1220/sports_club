import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_club/pages/login_page.dart';
import 'package:sports_club/resources/auth_methods.dart';
import 'package:sports_club/utils/colors.dart';

import '../Widgets/text_field_input.dart';
import '../helpers/utils.dart';
import '../utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  //pick image from gallery
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  //signUpUserFunction
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible(flex: 2, child: Container()),
                  Container(
                    height: 48,
                  ),
                  // svg image
                  SvgPicture.asset(
                    'assets/SportsClub.svg',
                    color:Colors.black,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  //ProfilePic
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  //textfield input for username
                  TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text),
                  const SizedBox(height: 24),
                  //textfield input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  //textfield input for password
                  TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(height: 24),
                  //textfield input for school
                  TextFieldInput(
                      textEditingController: _bioController,
                      hintText: 'Enter your description',
                      textInputType: TextInputType.text),
                  const SizedBox(height: 24),
                  //Login button
                  InkWell(
                    //pass data to sign up
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: appbarColor,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: primaryColor,
                            ))
                          : const Text('Sign up',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 64),
                  // Flexible(flex: 2, child: Container()),

                  //Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Log in!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            
          ),
        ),
      ),
    );
  }
}
