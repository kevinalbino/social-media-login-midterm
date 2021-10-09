// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kalbino_midterm/views/profile_page.dart';
import 'package:flutter/widgets.dart';

final usersRef = FirebaseFirestore.instance.collection('users').orderBy('fullname', descending: false);

class UserList extends StatefulWidget {
  UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              dense: true,
              title: Text(doc["fullname"],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blue),),
              subtitle:  Text(doc["joindate"],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: ClipOval(
                  child: Image.network(doc['picUrl'], scale: 1,)
                )
              ),
              trailing: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.keyboard_arrow_right),
                color: Colors.black,
                iconSize: 30,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(doc["fullname"], doc['picUrl'], doc['bio'], doc['hometown'], doc['age'])
                )
              ),
            ),
            const Divider(
              height: 25,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: usersRef.snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return Container(
                child: _buildList(snapshot.data!)
              );
            }
          ),
        ],
      )
    );
  }
}