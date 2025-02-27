import 'package:chat_app/login_module/AuthScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'chat_module/ChatScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _checkUserLoginStatus();
    super.initState();
  }

  void _checkUserLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time
    User? user = FirebaseAuth.instance.currentUser;
    if(!mounted) return;
    if (user != null) {
      debugPrint("the user value ${user.email}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen()),);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/chataa.png', width: 150), // Custom logo
      ),
    );
  }
}

