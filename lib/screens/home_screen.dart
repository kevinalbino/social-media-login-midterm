import 'package:flutter/material.dart';
import 'package:kalbino_midterm/services/auth.dart';
import 'package:kalbino_midterm/screens/pop_up.dart';
import 'package:kalbino_midterm/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:kalbino_midterm/views/user_list.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        elevation: 0,
        title: Text(
          'User List',
          style: TextStyle(fontSize: 35.0, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final action = await popUpView.yesCancelDialog(context, 'Logout', 'Are you sure?');
              if(action == DialogsAction.yes) {
                await GoogleSignInService().logOut();
                context.read<AuthService>().facebookLogOut();
                context.read<AuthService>().logOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => login_screen()));
              }
            },
            child: Container(
              height: 50,
              width: 25,
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),

      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 10),
          UserList(),
        ],
      ),

    );
  }
}