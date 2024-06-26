import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juan_work/Screens/profile_page.dart';
import 'package:juan_work/components/drawer.dart';
import 'package:juan_work/components/text_field.dart';
import 'package:juan_work/components/wall_post.dart';
import 'package:juan_work/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Get the user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //Text controller for message
  final postTextController = TextEditingController();

  //Post Message
  void postMessage() {
    //Only post if there is something in txtfield
    if (postTextController.text.isNotEmpty) {
      //Store in firebase
      FirebaseFirestore.instance.collection("User Posts").add(
        {
          'UserEmail': currentUser.email,
          'Message': postTextController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        },
      );
    }

    //Clear textfield after message
    setState(() {
      postTextController.clear();
    });
  }

  //Navigate to profile page
  void goToProfilePage() {
    //Pop menu drawer
    Navigator.pop(context);

    //Go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Posts',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MyDrawer(onProfileTap: goToProfilePage, onSignOut: (){
        AuthService authService = AuthService();
              authService.signOut();
              Navigator.pushNamed(context, '/login');
      }),
      body: Center(
        child: Column(
          children: [
            //Posts Wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //Get the message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          timestamp: post['TimeStamp'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            //Post Message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: postTextController,
                      hintText: "Post somthing on the wall...",
                      obscureText: false,
                    ),
                  ),
                  //Post button
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up)),
                ],
              ),
            ),

            //Logged in as
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
