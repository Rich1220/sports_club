import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_club/pages/add_page.dart';
import 'package:sports_club/pages/chat_page.dart';
import 'package:sports_club/pages/home_page.dart';
import 'package:sports_club/pages/profile_page.dart';
import 'package:sports_club/pages/search_page.dart';
import 'package:sports_club/providers/user_provider.dart';
import 'package:sports_club/utils/colors.dart';
import 'package:sports_club/models/user.dart' as model;

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  List pages = [
    CategoryListPage(key: null),
    const SearchPage(),
    const SelectedSchoolPage(),
    const ChatPage(),
    ProfilePage(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  void onTap(int index) {
    _currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: mobileBackgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          onTap: onTap,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                //icon: Icon(Icons.favorite),
                icon: Icon(Icons.calculate_rounded),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
                backgroundColor: primaryColor),
          ]),
    );
  }
}
