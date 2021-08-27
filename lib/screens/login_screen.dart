import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id="login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  String email;
  String password;
  FirebaseUser loggedUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser()async{
    try{
      final user = await _auth.currentUser();
      if(user != null){
        loggedUser = user;
        print(loggedUser.email);
      }
    }catch(e){
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextDecoration.copyWith(hintText: "Enter the email address")
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                decoration: kTextDecoration.copyWith(hintText: "Enter your password")
              ),
              SizedBox(
                height: 24.0,
              ),
              roundedButton(text: "Log in", color: Colors.lightBlueAccent,
                onPressed:
              () async {
                setState(() {
                  showSpinner=true;
                });
                try
                {final user = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (user != null) {
                  Navigator.pushNamed(context, ChatScreen.id);
                }
                setState(() {
                  showSpinner=false;
                });
                }catch(e)
                {
                  print(e);
                }

              },)
            ],
          ),
        ),
      ),
    );
  }
}
