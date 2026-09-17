/* 

USER PROFILE

This is what users see as their profile page. It displays their profile picture, name, username, bio, and a list of their tweets.
-------------------------------------------------------
-uid
-name
-email
-username
-bio
-profile picture( at the end)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });
  /*
  database to app object
  convert firestore document to profile object(use in app)
*/
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }

 /* 
  app to database object
  covert user profile to map(store in firebase)
  */
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}