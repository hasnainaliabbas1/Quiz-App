import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzer/quizintro.dart';
import 'package:quizzer/services/home_fire.dart';
import 'package:quizzer/services/localdb.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'widget/sidenavbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  final List<String> imgList = [
    'https://blogassets.leverageedu.com/blog/wp-content/uploads/2020/05/08111408/English-Quiz.png',
    'https://play-lh.googleusercontent.com/KIrzzUbp47hS_xfXWZsN2hlcqAtxv5C-IeuVlAsVnL4NA1cbgW5vqEEVM8RKBAESy5Y=w240-h480-rw',
    'https://play-lh.googleusercontent.com/kC20lwnEx9pBhg1i5eaazt5XqH4Qd5AIytH1E5-jlESbcg108b4zlCSksX_XhiL9r5M=w240-h480-rw',
    'https://www.quizexpo.com/wp-content/uploads/2021/02/cover-10-850x491.jpg'
  ];

  String name = "User Name";
  String money="--";
  String lead="---";
  String proUrl="---";
  String level="0";
  late List quizzes =[git ] ;
  getUserDetails() async{
    await LocalDB.getName().then((value){
      setState((){
        name = value.toString()  ;
      });
    });

    await LocalDB.getMoney().then((value){
      setState((){
        money = value.toString()  ;
      });
    });
    await LocalDB.getRank().then((value){
      setState((){
        lead = value.toString()  ;
      });
    });
    await LocalDB.getUrl().then((value){
      setState((){
        proUrl = value.toString()  ;
      });
    });
    await LocalDB.getLevel().then((value){
      setState((){
        level = value.toString()  ;
      });
    });
  }

  getquiz()async {
    await  HomeFire.getquizzes().then((returned_quizzes) {
      setState(() {
        quizzes = returned_quizzes;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getquiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent[100],
        appBar: AppBar(
          title: Text("Quizzer"),
          backgroundColor: Colors.purple[200],
        ),
        drawer: SideNav(name , money , lead,proUrl,level),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: imgList.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(imgList[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 180,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: imgList.length,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: Colors.purple,
                    dotColor: Colors.grey,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: Image.network(
                            "https://www.quizexpo.com/wp-content/uploads/2021/02/cover-10-850x491.jpg",
                            fit: BoxFit.fill,
                            width: 70, // Same as radius * 2
                            height: 70,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: Image.network(
                            "https://play-lh.googleusercontent.com/KIrzzUbp47hS_xfXWZsN2hlcqAtxv5C-IeuVlAsVnL4NA1cbgW5vqEEVM8RKBAESy5Y=w240-h480-rw",
                            fit: BoxFit.fill,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: Image.network(
                            "https://play-lh.googleusercontent.com/kC20lwnEx9pBhg1i5eaazt5XqH4Qd5AIytH1E5-jlESbcg108b4zlCSksX_XhiL9r5M=w240-h480-rw",
                            fit: BoxFit.fill,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: Image.network(
                            "https://blogassets.leverageedu.com/blog/wp-content/uploads/2020/05/08111408/English-Quiz.png",
                            fit: BoxFit.fill,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                )

                ,SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizIntro(
                                QuizAbout: quizzes[4]['about_quiz'],
                                QuizImgUrl: quizzes[4]['quiz_thumbnail'],
                                QuizTopics: quizzes[4]['topics'],
                                QuizDuration: quizzes[4]['duration'], // Ensure this value is calculated properly
                                QuizName: quizzes[4]['quiz_name'],
                                QuizId: quizzes[4]['Quizid'],
                                Quizprice: quizzes[4]['unlocked_money'],
                              ),
                            ),
                          );
                        },
                        child: Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      height: 170,
                                      width: 180,
                                      child: Image.network(
                                        quizzes[4]['quiz_thumbnail'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizIntro(
                                QuizAbout: quizzes[2]['about_quiz'],
                                QuizImgUrl: quizzes[2]['quiz_thumbnail'],
                                QuizTopics: quizzes[2]['topics'],
                                QuizDuration: quizzes[2]['duration'], // Ensure this value is calculated properly
                                QuizName: quizzes[2]['quiz_name'],
                                QuizId: quizzes[2]['Quizid'],
                                Quizprice: quizzes[2]['unlocked_money'],
                              ),
                            ),
                          );
                        },
                        child: Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Stack(
                              children: [
                                Card(

                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      height: 170,
                                      width: 165,
                                      child: Image.network(
                                          quizzes[2]['quiz_thumbnail']
                                          ,
                                        fit: BoxFit.fill,),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizIntro(
                            QuizAbout: quizzes[1]['about_quiz'],
                            QuizImgUrl: quizzes[1]['quiz_thumbnail'],
                            QuizTopics: quizzes[1]['topics'],
                            QuizDuration: quizzes[1]['duration'], // Ensure this value is calculated properly
                            QuizName: quizzes[1]['quiz_name'],
                            QuizId: quizzes[1]['Quizid'],
                            Quizprice: quizzes[1]['unlocked_money'],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Image.network(
                                quizzes[1]['quiz_thumbnail']
                                 ,
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Top Player In This Week",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Last Updated 5 Days Ago",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(proUrl),
                                radius: 50,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0), // Add padding for better spacing
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Use RichText for long text with overflow handling
                                      RichText(
                                        overflow: TextOverflow.visible, // Ensure the text is visible
                                        text: TextSpan(
                                          text: name,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4), // Adds space between text widgets
                                      // Regular Text widget for Player ID
                                      Text(
                                        "Player ID - ABD553",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )

                            ],
                          )
                        ])),

                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unlock New Quizzes",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            // First Quiz Container
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizIntro(
                                        QuizAbout: quizzes[0]['about_quiz'],
                                        QuizImgUrl: quizzes[0]['quiz_thumbnail'],
                                        QuizTopics: quizzes[0]['topics'],
                                        QuizDuration: quizzes[0]['duration'], // Ensure this value is calculated properly
                                        QuizName: quizzes[0]['quiz_name'],
                                        QuizId: quizzes[0]['Quizid'],
                                        Quizprice: quizzes[0]['unlocked_money'],
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 150,
                                          child: Image.network(
                                            quizzes[0]['quiz_thumbnail'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Second Quiz Container
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizIntro(
                                        QuizAbout: quizzes[3]['about_quiz'],
                                        QuizImgUrl: quizzes[3]['quiz_thumbnail'],
                                        QuizTopics: quizzes[3]['topics'],
                                        QuizDuration: quizzes[3]['duration'], // Ensure this value is calculated properly
                                        QuizName: quizzes[3]['quiz_name'],
                                        QuizId: quizzes[3]['Quizid'],
                                        Quizprice: quizzes[3]['unlocked_money'],
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // Set the radius to make the card circular
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          height: 150,
                                          width: 170,
                                          child: Image.network(
                                            quizzes[3]['quiz_thumbnail'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizIntro(
                                      QuizAbout: quizzes[5]['about_quiz'],
                                      QuizImgUrl: quizzes[5]['quiz_thumbnail'],
                                      QuizTopics: quizzes[5]['topics'],
                                      QuizDuration: quizzes[5]['duration'], // Ensure this value is calculated properly
                                      QuizName: quizzes[5]['quiz_name'],
                                      QuizId: quizzes[5]['Quizid'],
                                      Quizprice: quizzes[5]['unlocked_money'],
                                    ),
                                  ),
                                );
                              },
                              child: Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Container(
                                            height: 150,
                                            child: Image.network(
                                              quizzes[5]['quiz_thumbnail']
                                                                                 ,    fit: BoxFit.fill,
                                              width: 170,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizIntro(
                                          QuizAbout: quizzes[7]['about_quiz'],
                                          QuizImgUrl: quizzes[7]['quiz_thumbnail'],
                                          QuizTopics: quizzes[7]['topics'],
                                          QuizDuration: quizzes[7]['duration'], // Ensure this value is calculated properly
                                          QuizName: quizzes[7]['quiz_name'],
                                          QuizId: quizzes[7]['Quizid'],
                                          Quizprice: quizzes[7]['unlocked_money'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20), // Set the radius to make the card circular
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: Container(
                                            height: 150,
                                            width: 170,
                                            child: Image.network(
                                                quizzes[7]['quiz_thumbnail'],
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizIntro(
                                          QuizAbout: quizzes[6]['about_quiz'],
                                          QuizImgUrl: quizzes[6]['quiz_thumbnail'],
                                          QuizTopics: quizzes[6]['topics'],
                                          QuizDuration: quizzes[6]['duration'], // Ensure this value is calculated properly
                                          QuizName: quizzes[6]['quiz_name'],
                                          QuizId: quizzes[6]['Quizid'],
                                          Quizprice: quizzes[6]['unlocked_money'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Container(
                                            height: 150,
                                            width: 170,
                                            child: Image.network(
                                              quizzes[6]['quiz_thumbnail']
                                              ,fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(width: 10),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizIntro(
                                          QuizAbout: quizzes[8]['about_quiz'],
                                          QuizImgUrl: quizzes[8]['quiz_thumbnail'],
                                          QuizTopics: quizzes[8]['topics'],
                                          QuizDuration: quizzes[8]['duration'], // Ensure this value is calculated properly
                                          QuizName: quizzes[8]['quiz_name'],
                                          QuizId: quizzes[8]['Quizid'],
                                          Quizprice: quizzes[8]['unlocked_money'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Set the radius to make the card circular
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Container(
                                            height: 150,
                                            width:170,
                                            child: Image.network(
                                                quizzes[8]['quiz_thumbnail'],
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      /*Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 8,
                                      child: Container(
                                        height: 150,
                                        child: Image.network(
                                          "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(width: 10),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 8,
                                      child: Container(
                                        height: 150,
                                        child: Image.network(
                                            "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    children: [
                      Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Image.network(
                              "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),*/
                /*SizedBox(height: 30,),
                CarouselSlider(
                    items: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(

                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1632931612792-fbaacfd952f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1332&q=80",
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ],
                    options: CarouselOptions(
                        height: 180,

                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8)),*/



                SizedBox(height: 20,),
                Text("v1.0 Made By Hasnain Ali" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),)
              ],
            ),
          ),
        )

    );
  }
}
