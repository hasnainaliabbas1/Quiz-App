import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzer/Home.dart';
import 'package:quizzer/HomeScreen.dart';
import 'package:quizzer/about_us.dart';
import 'package:quizzer/how_to_use.dart';
import 'package:quizzer/profile.dart';

import '../services/localdb.dart';

class SideNav extends StatelessWidget {

  String name;
  String money;
  String rank;
  String proUrl;
  String level;
  SideNav( @required this.name ,@required this.money ,@required this.rank , @required this.proUrl, @required this.level);



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(128, 0, 128, 1),
        child: ListView(
          // padding:  EdgeInsets.symmetric(horizontal: 20),
          children: [
            GestureDetector(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(name: name,proUrl: proUrl,rank: rank,money: money,level:level,)));
              },

              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
                    child: Row(children: [
                      CircleAvatar(radius: 30, backgroundImage: NetworkImage(proUrl),),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name , style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold),),

                          ],
                        ),
                      )
                    ],),

                  ),

              Container(
                  padding: EdgeInsets.only(left: 25),
                  child: Text("Leaderboard - $rank th Rank" , style: TextStyle(color: Colors.white ,fontSize: 19,fontWeight: FontWeight.bold,))
              ),
                ],
              ),
            ),
            SizedBox(height: 24,),
            Divider(thickness: 1,indent: 10,endIndent: 10,),
            listItem(
                context:context,
                path: MaterialPageRoute(builder:(BuildContext context)=>HowToUseScreen()),
                label : "How To Use",
                icon : Icons.question_answer
            ),
            listItem(
                context:context,
                path: MaterialPageRoute(builder:(BuildContext context)=>AboutUsScreen()),
                label : "About Us",
                icon : Icons.face
            ),
            listItem(
                context:context,
                path: MaterialPageRoute(builder:(BuildContext context)=>Home()),
                label : "Logout",
                icon : Icons.logout
            )
          ],
        ),
      ),
    );
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required MaterialPageRoute path,

  }){
    final color = Colors.white;
    final hovercolor = Colors.white60;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    signOut() async {
      await googleSignIn.signOut();
      await _auth.signOut();
      await LocalDB.saveUserID("null");
      return "SUCCESS";
    }
    return ListTile(

      leading: Icon(icon , color: color,),
      hoverColor: hovercolor,
      title: Text(label , style: TextStyle(color: color)),
      onTap: () async{
        await signOut();
        Navigator.pushReplacement(context, path);
      },
    );
  }
}
