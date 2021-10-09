import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  final String fullname;
  final String picUrl;
  final String bio;
  final String hometown;
  final int age;

  ProfilePage(this.fullname, this.picUrl, this.bio, this.hometown, this.age);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
        title: Text(fullname,
        style: TextStyle(fontSize: 25.0, color: Colors.black)
        ),
      ),
      body:ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.blueAccent,
            child: ClipOval(
              child: Image.network(picUrl, scale: 0.25)
            )
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Text(
                  fullname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 4),
                Text(
                  "Hometown: $hometown",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  "Age: $age",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bio',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      bio,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
                SizedBox(height: 48),
              ],
            ),
          )
        ],
      )
    );
  }
}