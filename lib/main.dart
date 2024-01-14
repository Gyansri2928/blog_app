//import 'package:blog_app/home.dart';
//import 'package:blog_app/pages/login.dart';
import 'package:blog_app/pages/auth.dart';
import 'package:blog_app/pages/mapping.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog_App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home:  MappingPage(
        auth: Auth(),
      ),
    );
  }
}
