import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String name;
  final String proUrl;
  final String rank;
  final String level;
  final String money;

  Profile({
    required this.name,
    required this.proUrl,
    required this.level,
    required this.rank,
    required this.money,
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Map<String, dynamic>> users = [];
  int? myPosition;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> fetchedUsers = querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'photoUrl': doc['photoUrl'],
        };
      }).toList();

      // Randomize the positions of users
      fetchedUsers.shuffle();

      // Store the position of the current user
      for (int i = 0; i < fetchedUsers.length; i++) {
        if (fetchedUsers[i]['name'] == widget.name) {
          myPosition = i + 1;
          break;
        }
      }

      setState(() {
        users = fetchedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 29),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.proUrl),
                        radius: 50,
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.edit,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.name}\n",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("#${widget.rank} ",
                              style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.9))),
                          Text("Rank",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Leaderboard",
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    height: 300,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isCurrentUser = myPosition != null && myPosition == index + 1;
                        return ListTile(
                          tileColor: isCurrentUser ? Colors.blueAccent.withOpacity(0.2) : null,
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(users[index]['photoUrl']),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Flexible(
                                child: Text(
                                  users[index]['name'],
                                  overflow: TextOverflow.ellipsis, // This prevents the text from overflowing
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          leading: Text(
                            "#${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCurrentUser ? Colors.blueAccent : null,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        color: Colors.purple,
                        indent: 10,
                        endIndent: 10,
                      ),
                      itemCount: users.length,
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
