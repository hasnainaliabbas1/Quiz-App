import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quizzer/services/localdb.dart';
import 'HomeScreen.dart';
import 'services/firedb.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    final bool initialStatus = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = initialStatus;
    });
    showSimpleNotification(
      Text(isConnected ? "CONNECTED TO INTERNET" : "No Internet"),
      background: Colors.purple[400],
    );

    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (connected != isConnected) {
        setState(() {
          isConnected = connected;
        });
        showSimpleNotification(
          Text(connected ? "CONNECTED TO INTERNET" : "NO INTERNET"),
          background: connected ? Colors.green : Colors.red,
        );
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        assert(!user!.isAnonymous);
        assert(await user?.getIdToken() != null);
        final User? currentUser = _auth.currentUser;
        assert(currentUser!.uid == user?.uid);

        await FireDB().createnewuser(user!.displayName.toString(), user!.email.toString(), user.photoURL.toString());
        await LocalDB.saveUserID(user.uid);
        await LocalDB.saveName(user.displayName.toString());
        await LocalDB.saveUrl(user.photoURL.toString());

        print("User signed in successfully: ${user.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('GoogleSignInAccount is null.');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<String> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    await LocalDB.saveUserID("null");
    return "SUCCESS";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/lo.png", height: 150, width: 150,),
          Center(
            child: Text(
              'Welcome to Quiz App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space between the text and the button
          Center(
            child: SignInButton(
              Buttons.GoogleDark,
              onPressed: () => _signInWithGoogle(context),
            ),
          ),
          SizedBox(height: 10,),
          Text("By Continuing, You Are Agree With Our TnC", style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}
