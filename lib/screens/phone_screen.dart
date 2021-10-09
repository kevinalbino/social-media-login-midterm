// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kalbino_midterm/services/auth.dart';

class phone_screen extends StatefulWidget {
  phone_screen({Key? key}) : super(key: key);

  @override
  _phone_screenState createState() => _phone_screenState();
}

class _phone_screenState extends State<phone_screen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(top: 100, bottom: 25),
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 35),
                Text('Enter Phone Number',
                style: TextStyle(fontSize: 50.0),
                ),
                SizedBox(height: 35),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 0.3),
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          obscureText: true,
                          controller: _phoneController,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                            )
                          ),
                          onPressed: () {
                            final phoneNum = _phoneController.text.trim();
                            context.read<AuthService>().signInPhone(phoneNum, context);
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Return to other login methods: ",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 0.1,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context, 'login_screen'),
              child: Text("Back",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}