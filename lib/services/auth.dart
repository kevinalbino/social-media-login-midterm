import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:kalbino_midterm/screens/home_screen.dart';

class AuthService {

  final FirebaseAuth _auth;

  AuthService(this._auth);
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Logs in user with Email and Password
  Future<void> logIn(String email, String password, context) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Logged In');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  // User sign up with Email and Password
  Future<void> register(String email, String password, String fullName, context) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then(
        (value) async {
          User? user = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
            'uid': user.uid,
            'email': email,
            'fullname': fullName,
            'joindate': DateTime.now().toString().substring(0,10),
            'picUrl': "https://firebasestorage.googleapis.com/v0/b/kalbino-midterm.appspot.com/o/default_avatar.png?alt=media&token=7052868f-85ab-43ec-bd00-5d08af1f93e3",
            'bio': 'New User',
            'hometown': 'Earth',
            'age': 18,
          });
          await user.updateDisplayName(fullName);
      });
      print('Registered successfully');
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  // Signs in user anonymously without asking for any information
  Future<void> signInAnon(context) async {
    try{
      await _auth.signInAnonymously();
      print('Signed Anononymously');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
    } on FirebaseAuthException catch (e) {
      catchError(context, e);
    }
  }

  // Signs in and verifies user using their phone number
  Future<void> signInPhone(String phoneNum, context) async {
    final _codeController = TextEditingController();

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();
        try {
          await _auth.signInWithCredential(credential);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
        } on FirebaseAuthException catch (e) {
          catchError(context, e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        catchError(context, e.toString());
      },
      codeSent: (String verificationId, [forceResendingToken]) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter SMS code: "),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () async {
                    final code = _codeController.text.trim();
                    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                    try {
                      await _auth.signInWithCredential(credential);
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_screen()));
                    } on FirebaseAuthException catch (e) {
                      catchError(context, e);
                    }
                  },
                )
              ],
            );
          }
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {}
    );
  }

  // Sends link to user's email in order to sign in
  // Future<void> sendSignInEmailLink(String email, context) async {
  //   ActionCodeSettings actionCodeSettings = ActionCodeSettings.newBuilder()
  //       .setUrl("https://www.example.com/finishSignUp?cartId=1234")
  //       .setHandleCodeInApp(true)
  //       .setIOSBundleId("com.kalbino1.kalbino_midterm")
  //       .setAndroidPackageName("com.kalbino1.kalbino_midterm", true, "0")
  //       .build();

  //   try {
  //     await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: actionCodeSettings);
  //   } on FirebaseAuthException catch (e) {
  //     catchError(context, e);
  //   }
  // }

  // Allows user sign in using email without password
  Future<void> signInEmailLink(String email, String emailLink, context) async {

    if(_auth.isSignInWithEmailLink(emailLink)) {
      try {
        await _auth.signInWithEmailLink(email: email, emailLink: emailLink);
        print("Sign in successfully with email link");
      } on FirebaseAuthException catch (e) {
        catchError(context, e);
      }
    } else {
      print("Sign in link was not valid.");
    }
  }

  // User log in with Facebook
  Future<void> signInWithFacebook({required BuildContext context}) async {
    final result = await FacebookAuth.instance.login(permissions: ['public_profile', 'email']);
    final token = result.accessToken!.token;

    if(result.status == LoginStatus.success) {
      final credential = FacebookAuthProvider.credential(token);

      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        User? user = userCredential.user;
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
          'uid': user.uid,
          'email': user.email,
          'fullname': user.displayName.toString(),
          'joindate': DateTime.now().toString().substring(0,10),
          'picUrl': user.photoURL,
          'bio': 'New User',
          'hometown': 'Earth',
          'age': 18,
        });

      } on FirebaseAuthException catch (e) {
        catchError(context, e);
      }
    }
  }

  // Allows user to log out of Facebook
  Future<void> facebookLogOut() async {
    await FacebookAuth.instance.logOut();
  }

  // Displays any firebase authentication errors to user
  catchError(context, e) {
    final code = e.code;

    if(code == 'invalid-email') {
      e = "Please enter a valid email.";
    } else if(code == 'user-disabled') {
      e = "Your account was disabled.";
    } else if(code == 'user-not-found') {
      e = "Please sign up to create an account or log in with Google.";
    } else if(code == 'wrong-password') {
      e = "Your password is incorrect.";
    } else if(code == 'too-many-requests') {
      e = "Account access blocked. Try again later.";
    } else if(code == 'email-already-in-use') {
      e = " You already have an account.";
    } else if(code == 'operation-not-allowed') {
      e = "Your account is not enabled yet.";
    } else if(code == 'weak-password') {
      e = "Please create a stonger password.";
    }

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e.toString()),
      );
    });
  }

  // Allows user to signout
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Sends a verification link to user's email
  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }
}

class GoogleSignInService {

  // User log in with Google
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
          await auth.signInWithCredential(credential);

        user = userCredential.user;
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
          'uid': user.uid,
          'email': user.email,
          'fullname': user.displayName.toString(),
          'joindate': DateTime.now().toString().substring(0,10),
          'picUrl': user.photoURL,
          'bio': 'New User',
          'hometown': 'Earth',
          'age': 18,
        });
      } on FirebaseAuthException catch (e) {
        catchError(context, e);
      }
    }
    return user;
  }

  // User Sign out (Google)
  Future<void> logOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  // Displays any firebase authentication errors to user
  catchError(context, e) {
    final code = e.code;

    if(code == 'account-exists-with-different-credential') {
      e = "The account already exists with different credentials.";
    } else if(code == 'invalid-credential') {
      e = "Wrong credentials entered.";
    } else if(e) {
      e = "Error occured while using Google Sign-In.";
    }
    
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e),
      );
    });
  }
}