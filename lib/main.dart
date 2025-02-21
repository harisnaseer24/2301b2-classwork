import 'package:dbpractice/addproduct.dart';
import 'package:dbpractice/getproduct.dart';
import 'package:dbpractice/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn:isLoggedIn));
  }

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   isLoggedIn ? MyProducts() : Signin(),
      routes: {
        '/add':(context)=> isLoggedIn ? AddProduct() : Signin(),
        '/signup':(context)=>Signup(),
        '/signin':(context)=>Signin(),
        '/products':(context)=> isLoggedIn ? MyProducts() : Signin(),
      },
    );
  }
}

