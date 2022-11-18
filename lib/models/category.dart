import 'dart:ui';

class Category {
  String name;
  //String icon;
  String time;
  Color color;
  String imgName;
  String whopost;
  String whopostname;
  List<Category> subCategories;
  String location;
  String sport;
  String uid;
  String introduce;
  String limitnum;
  List<dynamic> joinlist;

  Category({
    required this.name,
    //required this.icon,
    required this.time,
    required this.color,
    required this.imgName,
    required this.subCategories,
    required this.whopost,
    required this.whopostname,
    required this.location,
    required this.sport,
    required this.uid,
    required this.introduce,
    required this.limitnum,
    required this.joinlist,
  });
}
