/*

DATABASE SERVICE
This class handles all data from the firebase.
-------------------------------------

-USER PROFILE
-POST MESSAGE
-LIKES
-COMMENTS
-ACCOUNT STUFF(REPORT/BLOCK/ DELETE ACCOUNT)
-FOLLOW / UNFOLLOW
-SEARCH USERS 
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone/models/user.dart';
import 'dart:developer' as developer;


class DatabaseService {
  //get instance of firestore db & auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*

  USER PROFILE
 When user signs up, a new user profile is created in the database. 
 This profile contains the user's uid, name, email, username, and bio. 
 The profile can be updated by the user at any time.
 lets also store their data in a database to 
 show it on their profile page 
 and to other users when they search for them.

  */
  // Save user info
  Future<void> saveUserInfoInFirebase({required String name, required String email})async{
    //get uid of current user
    String uid = _auth.currentUser!.uid;
    // extract user name from email
    String username = email.split('@')[0];
    //create user profile object
    UserProfile userProfile = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );
    //convert user into map to store in firebase
    final userMap = userProfile.toMap();
    //save user in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try{

        //retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      //convert doc to user profile object
      return UserProfile.fromDocument(userDoc);
    
    }
    catch(e){
      //print(e);
      developer.log('your message here');
      return null;
    }
  }

  /*

  Post Message

  */
  /*
  Likes

  */
  /*
  Comments

  */
  /*
  Bio

  */
  /*
  Account Stuff

  */
  /*
  Follow / Unfollow

  */
  /*
  Search Users

  */
}