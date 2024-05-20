import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/firebase_options.dart';

import 'ui/home/home_tab.dart';

void main() async {
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Century',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0),
          titleMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
          titleSmall: TextStyle(fontSize: 18.0),
          bodyLarge: TextStyle(fontSize: 18.0),
          labelSmall: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
