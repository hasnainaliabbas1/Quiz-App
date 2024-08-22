import 'package:cloud_firestore/cloud_firestore.dart';
import 'localdb.dart';

class Quizint {
  static Future<bool> buyQuiz({required int QuizPrice, required String QuizID}) async {
    String? user_id = await LocalDB.getUserID();
    if (user_id == null) {
      print("User ID is null");
      return false; // Handle this case as needed
    }

    bool paisaHaiKya = false;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(user_id).get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData["money"] != null) {
        int currentMoney = int.parse(userData["money"].toString());
        if (QuizPrice <= currentMoney) {
          paisaHaiKya = true;
          int remainingMoney = currentMoney - QuizPrice;

          // Update the user's money in Firestore
          await FirebaseFirestore.instance.collection("users").doc(user_id).update({
            "money": remainingMoney.toString(),
          });

          // Unlock the quiz
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user_id)
              .collection("unlocked_quiz")
              .doc(QuizID)
              .set({"unlocked_at": DateTime.now()});

          // DO YOUR TASK HERE
          print("QUIZ IS UNLOCKED NOW");
          return true;
        }
      }
    }

    if (!paisaHaiKya) {
      print("PAISA KAMA KE AAO PEHLE");
    }
    return false;
  }
}
