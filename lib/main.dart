import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app_flutter/firebase_options.dart';
import 'ui/home/home_tab.dart';
import 'ui/home/view_modles.dart';

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
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'Century',
              textTheme: const TextTheme(
                titleLarge:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(fontSize: 18.0),
                titleMedium:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
                titleSmall: TextStyle(fontSize: 18.0),
                bodyLarge: TextStyle(fontSize: 18.0),
                labelSmall:
                    TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ),
            themeMode: viewModles.themeMode.value,
            darkTheme: ThemeData.dark(),
            home: const MyHomePage(),
          );
        });
  }
}
