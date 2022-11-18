

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;


  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.bio,
    required this.username,
    required this.followers,
    required this.following,
  });
  factory User.fromJson(DocumentSnapshot json) {
    return User(
        email: json['email'],
        uid: json['uid'],
        photoUrl: json['photoUrl'],
        bio: json['bio'],
        username: json['username'],
        followers: json['followers'],
        following: json['following']);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
