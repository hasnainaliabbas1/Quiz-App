import 'package:flutter/material.dart';
import 'package:quizzer/question.dart';

class Looser extends StatelessWidget {
  final int wonMon;
  final List<String> incorrectAnswers;
  final String quizId;
  final int queMoney;
  final int totalQuestions; // Add total questions
  final int incorrectAnswersCount; // Add incorrect answers count

  Looser({
    required this.wonMon,
    required this.incorrectAnswers,
    required this.quizId,
    required this.queMoney,
    required this.totalQuestions,
    required this.incorrectAnswersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("images/loose.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          child: Text("Retry"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Question(
                  quizId: quizId,
                  queMoney: queMoney,
                ),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50), // Add some space at the top
                Text(
                  "Oh Sorry!",
                  style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Your Answers are Incorrect",
                  style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(
                  "Correct Answers for Incorrectly Answered Questions:",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true, // Ensures the list only takes up the necessary space
                  physics: NeverScrollableScrollPhysics(), // Disable list's own scrolling
                  itemCount: incorrectAnswers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Text(
                        incorrectAnswers[index],
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "$incorrectAnswersCount out of $totalQuestions questions were incorrect.",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50), // Add some space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
