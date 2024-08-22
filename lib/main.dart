import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quizzer/Home.dart';
import 'package:quizzer/HomeScreen.dart';
import 'package:quizzer/services/localdb.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);




  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  bool isLogIn = false;

  getLoggedInState() async{
    await LocalDB.getUserID().then((value){
      setState((){
        isLogIn = value.toString() != "null" ;
      });
    });
  }



  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global (
      child: MaterialApp (
        debugShowCheckedModeBanner: false,
        title: 'KBC Quiz',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home:  isLogIn ? Home(): HomeScreen(),
      ),
    );
  }
}