import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Song> songs = [];
  List<Song> favoriteSongList = [];
  late MusicAppViewModles _viewModles;
  @override
  void initState() {
    super.initState();
    _viewModles = MusicAppViewModles();
    _viewModles.loadSong();
    observeData();
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

  @override
  void dispose() {
    _viewModles.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool isLoading = songs.isEmpty;
    if (isLoading) {
      return getProgessBar();
    } else {
      return getListView();
    }
  }

  Widget getProgessBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView() {
    return ListenableBuilder(
        listenable: _viewModles,
        builder: (context, _) {
          return ListView.separated(
            itemCount: songs.length,
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
        });
  }

  Widget getRow(int a) {
    return _SongSelection(song: songs[a], parent: this);
  }

  void observeData() {
    _viewModles.songStream.stream.listen((event) {
      setState(() {
        songs.addAll(event);
      });
    });

  }

  void navigator(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songList: songs,
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
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8),
      title: Text(widget.song.title),
      subtitle: Text(widget.song.artist),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/itunes.jfif',
          image: widget.song.image,
          height: 48,
          width: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/itunes.jfif',
              height: 48,
              width: 48,
            );
          },
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {},
      ),
      onTap: () {
        widget.parent.navigator(widget.song);
      },
    );
  }
}
