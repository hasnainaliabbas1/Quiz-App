import 'package:flutter/material.dart';
import 'package:quizzer/services/QuestionModel.dart';
import 'package:quizzer/services/QuizQuestionCreator.dart';
import 'package:quizzer/winingscreen.dart';
import 'lossing.dart';
import 'dart:async';

class Question extends StatefulWidget {
  final String quizId;
  final int queMoney;

  Question({required this.quizId, required this.queMoney});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int incorrectAnswersCount = 0; // Count of incorrect answers
  int remainingTime = 30;
  Timer? timer;
  QuestionModel questionModel = QuestionModel();
  String selectedOption = "";
  List<String> incorrectAnswers = []; // List to store incorrect answers

  @override
  void initState() {
    super.initState();
    genQuestions();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer?.cancel();
          goToNextQuestion();
        }
      });
    });
  }

  Future<void> genQuestions() async {
    try {
      questions = await QuizQueCreator.genAllQuizQues(widget.quizId);
      questions.shuffle();

      setState(() {
        loadQuestion();
      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No questions found for the quiz.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void loadQuestion() {
    if (currentQuestionIndex < questions.length) {
      Map<String, dynamic> queData = questions[currentQuestionIndex];

      setState(() {
        remainingTime = 30;
        selectedOption = "";

        questionModel.question = queData["question"] ?? "";
        questionModel.correctAnswer = queData["correctAnswer"];

        List<String> options = [
          queData["opt1"] ?? "",
          queData["opt2"] ?? "",
          queData["opt3"] ?? "",
          queData["opt4"] ?? "",
        ];
        options.shuffle();

        questionModel.option1 = options[0];
        questionModel.option2 = options[1];
        questionModel.option3 = options[2];
        questionModel.option4 = options[3];

        startTimer();
      });
    } else {
      checkFinalResult();
    }
  }

  void checkFinalResult() {
    if (correctAnswers >= (questions.length * 2 / 3)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Win(
            totalQuestions: questions.length,
            correctAnswers: correctAnswers,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Looser(
            wonMon: (widget.queMoney ~/ 2),
            incorrectAnswers: incorrectAnswers, // Pass incorrect answers
            quizId: widget.quizId,
            queMoney: widget.queMoney,
            totalQuestions: questions.length, // Pass total questions count
            incorrectAnswersCount: incorrectAnswersCount, // Pass incorrect answers count
          ),
        ),
      );
    }
  }

  void goToNextQuestion() {
    timer?.cancel();

    if (selectedOption.isNotEmpty && selectedOption == questionModel.correctAnswer) {
      correctAnswers++;
    } else {
      incorrectAnswersCount++;
      // Add the correct answer to the list if the user answered incorrectly or unattempted
      incorrectAnswers.add("Correct answer for '${questionModel.question}' is '${questionModel.correctAnswer}'");
    }

    setState(() {
      currentQuestionIndex++;
      loadQuestion();
    });
  }

  void checkAnswer(String selectedOption) {
    setState(() {
      this.selectedOption = selectedOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Rs.${widget.queMoney}", style: TextStyle(fontSize: 25)),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent[200],
        ),
        floatingActionButton: ElevatedButton(
          child: Text("QUIT GAME", style: TextStyle(fontSize: 27)),
          onPressed: () {
            timer?.cancel();
            Navigator.pop(context);
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: remainingTime / 30,
                    strokeWidth: 12,
                    backgroundColor: Colors.green,
                  ),
                  Center(
                    child: Text(
                      "$remainingTime",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                questionModel.question.isNotEmpty
                    ? questionModel.question
                    : "No question available",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            buildOptionContainer("A", questionModel.option1, Colors.red.withOpacity(0.8)),
            buildOptionContainer("B", questionModel.option2, Colors.green.withOpacity(0.8)),
            buildOptionContainer("C", questionModel.option3, Colors.yellow.withOpacity(0.8)),
            buildOptionContainer("D", questionModel.option4, Colors.white.withOpacity(0.4)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goToNextQuestion(),
              child: Text("Next Question", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionContainer(String optionLabel, String optionText, Color color) {
    bool isSelected = selectedOption == optionText;

    return GestureDetector(
      onTap: optionText.isNotEmpty
          ? () {
        checkAnswer(optionText);
      }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
        decoration: BoxDecoration(
          color: optionText.isNotEmpty
              ? (isSelected ? Colors.blueAccent : color)
              : Colors.grey,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Text(
          optionText.isNotEmpty ? "$optionLabel. $optionText" : "",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
