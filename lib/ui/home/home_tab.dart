import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import '../library/library_tab.dart';
import '../search/search_tab.dart';
import '../setting/setting_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Song> favoriteList = [];
  List<Song> nowPlayingList = [];
  final List<Widget> _tabs = [
    const HomeTab(),
    const LibraryTab(),
    const SearchTab(),
    const SettingTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(iconSize: 35, items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ]),
        tabBuilder: (context, index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // List<Song> songs = [];
  // List<Song> favoriteSongList = [];
  late MusicAppViewModles _viewModles;
  late MusicService _musicService;
  @override
  void initState() {
    super.initState();
    _viewModles = MusicAppViewModles();
    _musicService = MusicService();

    // _viewModles.loadSong();
    // observeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: _musicService.getBody(_viewModles.songList, _viewModles),
    );
  }

  // @override
  // void dispose() {
  //   _viewModles.songStream.close();
  //   super.dispose();
  // }
}
