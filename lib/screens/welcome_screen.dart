import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id="welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation animation3;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
          duration: Duration(seconds: 1),
          vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    animation3 = ColorTween(begin: Colors.blueGrey, end: Colors.grey.shade300).animate(controller) ;
    controller.forward();
    controller.addStatusListener((status) {
      print(status);
    });
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }
@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation3.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: (controller.value*60),
                  ),
                ),
                WavyAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            roundedButton(color: Colors.lightBlueAccent, text: "Log in",
                onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            } ),
            roundedButton(color: Colors.blueAccent, text: "Register",
                onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            } )
          ],
        ),
      ),
    );
  }
}

