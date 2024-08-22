import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'localdb.dart';

class FireDB {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Random _random = Random();

  // Method to create a new user
  Future<void> createnewuser(String name, String email, String photoUrl) async {
    final User? current_user = _auth.currentUser;
    if (current_user == null) {
      print("No user is currently signed in.");
      return;
    }

    if (await getUser()) {
      print("User Already Exists");
    } else {
      // Generate a random rank between 1 and 100
      int randomRank = _random.nextInt(100) + 1;
      String rank = randomRank.toString();

      await FirebaseFirestore.instance.collection("users").doc(current_user.uid).set({
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "money": "10000",
        "rank": rank,
        "level": "0",
      }).then((value) async {
        await LocalDB.saveMoney("10000");
        await LocalDB.saveRank(rank); // Save the random rank
        await LocalDB.saveLevel("0");
        print("User Registered Successfully");
      }).catchError((error) {
        print("Failed to register user: $error");
      });
    }
  }

  // Method to get user data
  Future<bool> getUser() async {
    final User? current_user = _auth.currentUser;
    if (current_user == null) {
      return false;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(current_user.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      await LocalDB.saveMoney(userData["money"]);
      await LocalDB.saveRank(userData["rank"]);
      await LocalDB.saveLevel(userData["level"]);
      return true;
    } else {
      return false;
    }
  }
}
