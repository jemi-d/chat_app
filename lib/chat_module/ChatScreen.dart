import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_module/AuthScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  User? _user;
  String _receiverEmail = ""; // Store receiver's email

  @override
  void initState() {
    _user = _auth.currentUser;
    debugPrint("${_user?.email}");
    super.initState();
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && _receiverEmail.isNotEmpty) {
      await _firebaseFirestore.collection('messages').add({
        'sender': _user!.email,
        'receiver': _receiverEmail,
        'text': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  void logout() async {
    await _auth.signOut();
    if(!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  void _deleteMessage(String messageId) async {
    await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();
  }

  void _clearChat() async {
    var messages = await FirebaseFirestore.instance.collection('messages').get();
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat",
        style: TextStyle(fontSize: 20,color: Colors.teal),),backgroundColor: Colors.tealAccent,
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            showLogoutPopup(false);
          }),
          IconButton(icon: Icon(Icons.delete_sweep_outlined), onPressed: (){
            showLogoutPopup(true);
          }),
        ],),
      body: Column(children: [Padding(padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) => _receiverEmail = value,
          decoration: InputDecoration(labelText: "Enter recipient's email"),),
      ),
        Expanded(child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore
              .collection('messages')
              .where('receiver', isEqualTo: _user!.email) // Fetch only relevant messages
              .orderBy('timestamp', descending: true) // Fetch in correct order
              .limit(20) // Limit messages to reduce load time
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var messages = snapshot.data!.docs;
            return ListView.builder(itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                    return ListTile(title: Text(message['text'],style: TextStyle(color: Colors.teal,fontSize: 16),),
                      subtitle: Text("From: ${message['sender']}",style: TextStyle(color: Colors.teal,fontSize: 11),),
                      onLongPress: () => _deleteMessage(message.id),);},);
            },),
        ),
          Padding(padding: const EdgeInsets.all(8.0),
            child: Row(children: [ Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(hintText: "Enter message...",
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent,width: 1,style: BorderStyle.solid),),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2)),),
              ),), IconButton(icon: Icon(Icons.send,color: Colors.teal,),
              onPressed: _sendMessage,),],
            ),
          ),
        ],
      ),
    );
  }

  showLogoutPopup(bool isClearChat){
    String title = isClearChat ? "Clear Chat" : "Logout";
    String text = isClearChat ? "This makes clear all the Chat!!" : "Are you sure you want to logout?";
    String btnText = isClearChat ? "Clear" : "Logout";

    showDialog(
        context: context,builder: (context){
      return AlertDialog(title: Text(title),content: Text(text),
        actions: [
          Center(child: ElevatedButton(onPressed: (){
            isClearChat ? _clearChat() :logout();
          }, child: Text(btnText)),)
        ],);
    });
  }

}
