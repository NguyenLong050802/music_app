import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app_flutter/firebase_options.dart';
import 'ui/account/sign_in.dart';
import 'ui/home/home_tab.dart';
import 'ui/view_modles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModles = MusicAppViewModles();
    return ValueListenableBuilder(
        valueListenable: viewModles.themeMode,
        builder: (__, value, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: const ColorScheme(
                primary: Colors.deepPurple,
                secondary: Colors.black87,
                onPrimary: Colors.lightBlue,
                surface: Colors.white,
                error: Colors.red,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.black,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'Century',
              textTheme: const TextTheme(
                titleLarge: TextStyle(fontSize: 24.0),
                bodyMedium: TextStyle(fontSize: 18.0),
                titleMedium: TextStyle(fontSize: 30.0),
                titleSmall: TextStyle(fontSize: 20.0),
                bodyLarge: TextStyle(fontSize: 18.0),
                labelSmall: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            themeMode: viewModles.themeMode.value,
            darkTheme: ThemeData(
              colorScheme: const ColorScheme(
                primary: Colors.lightBlueAccent,
                secondary: Colors.white,
                onPrimary: Colors.lightBlue,
                surface: Colors.black,
                error: Colors.red,
                onSecondary: Colors.white70,
                onSurface: Colors.black,
                onError: Colors.black,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Century',
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
                bodyMedium: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                titleMedium: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
                titleSmall: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                bodyLarge: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                labelSmall: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MyHomePage();
                } else {
                  return const SignInPage();
                }
              },
            ),
          );
        });
  }
}
