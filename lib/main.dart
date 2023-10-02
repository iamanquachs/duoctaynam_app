import 'package:app_dtn/screens/home/home.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(241, 250, 254, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green,
        ),
      ),
      home: const Home(title: ''),
    );
  }
}
