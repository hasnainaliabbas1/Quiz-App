import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQueCreator {
  // Method to fetch a random question based on quizId and queMoney
  static Future<Map<String, dynamic>> genQuizQue(String quizId, int queMoney) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .where('money', isEqualTo: queMoney.toString())
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Random random = new Random();
      int randomIndex = random.nextInt(querySnapshot.docs.length);
      DocumentSnapshot quizDoc = querySnapshot.docs[randomIndex];

      return quizDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception("No question found for the specified money value.");
    }
  }

  // Method to fetch all questions for a specific quiz
  static Future<List<Map<String, dynamic>>> genAllQuizQues(String quizId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .get();

    List<Map<String, dynamic>> questions = [];

    for (var doc in querySnapshot.docs) {
      questions.add(doc.data() as Map<String, dynamic>);
    }

    if (questions.isNotEmpty) {
      return questions;
    } else {
      throw Exception("No questions found for the quiz.");
    }
  }
}
