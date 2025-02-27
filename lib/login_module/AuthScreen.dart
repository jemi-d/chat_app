import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chat_module/ChatScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true; // Toggle between login & register

  void _authenticate() async {
    try {
      if (_isLogin) {
        // Sign in user
        await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      } else {
        // Register user
        // await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

        // Register new user and store in Firestore
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text,
          'uid': userCredential.user!.uid,
        });
      }

      if(!mounted) return;

      // Navigate to Chat Screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Login" : "Register",style: TextStyle(color: Colors.teal,fontSize: 18),)
        ,backgroundColor: Colors.tealAccent,centerTitle: true,),
      body: Padding(padding: EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password",),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
              onPressed: _authenticate,
              child: Text(_isLogin ? "Login" : "Register",style: TextStyle(color: Colors.teal),),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin
                  ? "Don't have an account? Register"
                  : "Already have an account? Login", style: TextStyle(color: Colors.teal),),
            ),
          ],
        ),
      ),
    );
  }
}
