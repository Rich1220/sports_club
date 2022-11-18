import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_club/models/post.dart';
import 'package:sports_club/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  // Future<String> uploadPost(
  //   String description,
  //   Uint8List file,
  //   String uid,
  //   String username,
  //   String profileImage,
  // ) async {
  //   String res = "some error occurred!";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1();
  //     Post post = Post(
  //         description: description,
  //         uid: uid,
  //         username: username,
  //         postId: postId,
  //         datePublished: DateTime.now(),
  //         postUrl: photoUrl,
  //         profileImage: profileImage,
  //         likes: []);

  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      //already like the post
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //deleting post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = await (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> participate(String uid, String activityID)async{
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Users').doc(activityID).get();
      List joinlist = await (snap.data()! as dynamic)['joinlist'];
      if (joinlist.contains(uid)) {
        await _firestore.collection('Users').doc(activityID).update({
          'joinlist': FieldValue.arrayRemove([uid])
        });
        
      } else {
        await _firestore.collection('Users').doc(activityID).update({
          'joinlist': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> createEvent(String uid) async {
    try {
      if (uid.isNotEmpty) {
        await _firestore
            .collection('events')
            .doc(uid)
            .set({
          'events': [],
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addEvent(String uid, List Event)async{
    
      DocumentSnapshot snap =
          await _firestore.collection('events').doc(uid).get();
      List eventlist = await (snap.data()! as dynamic)['events'];
      
        await _firestore.collection('events').doc(uid).update({
          'events': FieldValue.arrayUnion(Event.toList())
        });
  }

}
