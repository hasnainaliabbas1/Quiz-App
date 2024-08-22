import 'package:flutter/material.dart';
import 'package:quizzer/question.dart';
import 'package:quizzer/services/QuizInt.dart';
import 'package:quizzer/services/checkQuizUnlock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizIntro extends StatefulWidget {
  final String QuizName;
  final String QuizImgUrl;
  final String QuizTopics;
  final String QuizAbout;
  final String QuizId;
  final String Quizprice;
  final String QuizDuration;
  QuizIntro({
    required this.QuizAbout,
    required this.QuizImgUrl,
    required this.QuizName,
    required this.QuizTopics,
    required this.QuizId,
    required this.Quizprice,
    required this.QuizDuration
  });

  @override
  _QuizIntroState createState() => _QuizIntroState();
}

class _QuizIntroState extends State<QuizIntro> {
  bool quizIsUnlocked = false;
  String duration = "Loading...";
  int totalQuestions = 0;
  @override
  void initState() {
    super.initState();
    getQuizUnlockStatus();
    fetchDuration();
  }

  getQuizUnlockStatus() async {
    bool unlockStatus = await CheckQuizUnlock.CheckQuizUnlockStatus(
        widget.QuizId);
    setState(() {
      quizIsUnlocked = unlockStatus;
    });
  }

  fetchDuration() async {
    try {
      // Reference to the questions subcollection
      final questionsRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.QuizId)
          .collection('questions');

      // Get all the documents in the questions subcollection
      final questionsSnapshot = await questionsRef.get();

      if (questionsSnapshot.docs.isNotEmpty) {
        // Count the number of documents in the questions subcollection
        final questionsCount = questionsSnapshot.docs.length;
        totalQuestions=questionsCount;

        // Calculate the total duration in seconds
        final totalSeconds = questionsCount * 30;

        // Convert total seconds to minutes and seconds
        final minutes = totalSeconds ~/ 60;
        final seconds = totalSeconds % 60;

        // Format the duration as "X minutes and Y seconds"
        setState(() {
          duration = "$minutes minute${minutes != 1 ? 's' : ''}"
              "${seconds > 0
              ? " and $seconds second${seconds != 1 ? 's' : ''}"
              : ''}";
        });
      } else {
        setState(() {
          duration = "Questions not available";
        });
      }
    } catch (e) {
      // Log the error for debugging
      print("Error fetching duration: $e");
      setState(() {
        duration = "Error fetching duration";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
        ),
        child: Text(
          quizIsUnlocked ? "START QUIZ" : "UNLOCK QUIZ",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          if (quizIsUnlocked) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Question(quizId: widget.QuizId, queMoney: 10)));
          } else {
            Quizint.buyQuiz(
              QuizPrice: int.parse(widget.Quizprice),
              QuizID: widget.QuizId,
            ).then((quizUnlockedHai) {
              if (quizUnlockedHai) {
                setState(() {
                  quizIsUnlocked = true;
                });
              } else {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text(
                            "You don't have enough money to buy this Quiz!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                );
              }
            });
          }
        },
      ),
      appBar: AppBar(
        title: Text("Quizzer"),
        backgroundColor: Colors.purple[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.QuizName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Image.network(
                widget.QuizImgUrl,
                fit: BoxFit.fill,
                height: 230,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.topic_outlined),
                        SizedBox(width: 6),
                        Text(
                          "Related To -",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                    Text(
                      widget.QuizTopics,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer),
                        SizedBox(width: 6),
                        Text(
                          "Duration -",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                    Text(
                      duration,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.question_answer),
                        SizedBox(width: 6),
                        Text(
                          "Total Questions -",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                    Text(
                      "$totalQuestions Questions",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              quizIsUnlocked ? Container() : Container(

                /*child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money),
                        SizedBox(width: 6),
                        Text(
                          "Money -",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                    Text(
                      "${widget.Quizprice} Rs",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),*/
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 6),
                        Text(
                          "About Quiz -",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                    Text(
                      widget.QuizAbout,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}