import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore=Firestore.instance;
  FirebaseUser loggedUser;

class ChatScreen extends StatefulWidget {
  static String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth=FirebaseAuth.instance;

  String messageText;

  int c=0;

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
  // void messageStream()async{
  //   await for (var snapshot in _firestore.collection("messages").snapshots()){
  //     for(var message in snapshot.documents){
  //       print(message.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection("messages").add({
                        "id": c++,
                        "text": messageText,
                        "sender": loggedUser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return             StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<MessageBubble> messageBubbles=[];
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages=snapshot.data.documents.reversed;
        for (var message in messages){
          final messageText = message.data["text"];
          final messageSender = message.data["sender"];
          final currentUser=loggedUser.email;

          final messageWidget = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children:  messageBubbles,
          ),
        );

      },
    );
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          ),
          Material(
            borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30),
                bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30) )
            : BorderRadius.only(topRight: Radius.circular(30),bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30) )
            ,
            elevation: 8,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20, vertical: 10 ),
              child: Text(
              text,
style:TextStyle(
  color: isMe ? Colors.white : Colors.black,
fontSize: 17
)
),
            ),
          ),
        ],
      ),
    );
  }
}

