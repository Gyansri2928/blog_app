import 'package:blog_app/pages/auth.dart';
import 'package:blog_app/pages/picupload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/posts.dart';

class HomePage extends StatefulWidget {
  final AuthServices? auth;
  final VoidCallback? onSignedout;
  const HomePage({super.key, this.auth, this.onSignedout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList=[];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsref = FirebaseDatabase.instance.ref().child("Posts");
    postsref.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic,dynamic>?;

      if (values == null) {
        // Handle the case where there is no data
        return;
      }

      postList.clear();
      values.forEach((key, value) {
        Posts post = Posts(
          value['image'],
          value['description'],
          value['Date'],
          value['time'],
        );
        postList.add(post);
      });

      setState(() {
        print('Length: $postList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth?.signout();
      widget.onSignedout!();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
            child: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Container(
        child: postList.length==0 ? Center(child: Text("No Blog post available")):
            ListView.builder(
              itemCount: postList.length,
                itemBuilder: (context,index){
                  return PostsUI(
                      postList[index].image,
                      postList[index].description,
                      postList[index].Date,
                      postList[index].time
                  );
                })
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        color: Colors.blue.shade700,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: _logoutUser,
                icon: const Icon(Icons.logout),
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadPhotoPage()));
                },
                icon: const Icon(Icons.add_a_photo),
                iconSize: 38,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget PostsUI(String image, String description, String date, String time) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0, // Adjust the height as needed
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
