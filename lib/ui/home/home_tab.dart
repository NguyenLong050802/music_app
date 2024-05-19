import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/custom/custom_list_title.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';

import '../../data/models/song.dart';
import '../discovery/discovery_tab.dart';
import '../nowplaying/now_playing.dart';
import '../profile/profile_tab.dart';
import '../setting/setting_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Song> favoriteList = [];
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const ProfileTab(),
    const SettingTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(iconSize: 35, items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
      body: getBody(),
    );
  }

  // @override
  // void dispose() {
  //   _viewModles.songStream.close();
  //   super.dispose();
  // }

  Widget getBody() {
    return ListenableBuilder(
        listenable: _viewModles,
        builder: (context, _) {
          if (_viewModles.songList.isNotEmpty) {
            return getListView();
          } else {
            return getProgessBar();
          }
        });
  }

  Widget getProgessBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView() {
    return ListView.separated(
      itemCount: _viewModles.songList.length,
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      shrinkWrap: true,
    );
  }

  Widget getRow(int a) {
    return _SongSelection(song: _viewModles.songList[a], parent: this);
  }

  // void observeData() {
  //   _viewModles.songStream.stream.listen((event) {
  //     setState(() {
  //       songs.addAll(event);
  //     });
  //   });

  // }

  void navigator(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songList: _viewModles.songList,
        playingSong: song,
      );
    }));
  }
}

class _SongSelection extends StatefulWidget {
  final Song song;
  final _HomeTabState parent;
  const _SongSelection({required this.song, required this.parent});

  @override
  State<_SongSelection> createState() => __SongSelectionState();
}

class __SongSelectionState extends State<_SongSelection> {
  @override
  Widget build(BuildContext context) {
    return MyListTitle(
      title: widget.song.title,
      leading: Leading(image: widget.song.image),
      subTitle: widget.song.artist,
      trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            widget.parent._musicService.showBottomSheet(context, widget.song);
          }),
      onTap: () {
        widget.parent.navigator(widget.song);
      },
    );
  }
}
