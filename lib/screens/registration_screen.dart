import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id="registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  FirebaseUser loggedUser;
  bool showSpinner=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser()async{
    try{
      final user = await _auth.currentUser();
      if(user != null){
        loggedUser = user as FirebaseUser;
        print(loggedUser.email);
      }
    }catch(e){
      print(e);
    }

  }

  String email;
  String password;
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
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextDecoration.copyWith(hintText: "Enter the email address")
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextDecoration.copyWith(hintText: "Enter your password")
              ),
              SizedBox(
                height: 24.0,
              ),
              roundedButton(text: "Register", color: Colors.blueAccent,
              onPressed: () async {
                setState(() {
                  showSpinner=true;
                });
                // print(email);
                // print(password);
                try{
               final newUser=await _auth.createUserWithEmailAndPassword(email: email, password: password);
               if(newUser!=null){
                 Navigator.pushNamed(context, ChatScreen.id);
               }
               setState(() {
                 showSpinner=false;
               });
              }
                catch (e){
                  print(e);
                }
              }

              )
            ],
          ),
        ),
      ),
    );
  }
}
