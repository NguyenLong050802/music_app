import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/account/profile.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/view_modles.dart';
import '../../data/models/song.dart';
import '../custom/custom_list.dart';
import '../custom/custom_textfield.dart';
import '../library/library_tab.dart';
import '../discovery/discovery_tab.dart';
import '../setting/setting_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.album_rounded),
            label: 'Discovery',
          ),
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
  late MusicAppViewModles _viewModles;
  late User user;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _viewModles = MusicAppViewModles();
    user = FirebaseAuth.instance.currentUser!;
    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });
    log(user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Profile(user: user),
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Builder(builder: (context) {
            return InkWell(
              child: avatar(user.photoURL ?? placeholderImage, 30, 40),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _viewModles.isDecrement,
                              builder: (_, value, __) {
                                return MediaIconButton(
                                  icon: _viewModles.isDecrement.value == true
                                      ? Icons.arrow_upward_outlined
                                      : Icons.arrow_downward_rounded,
                                  onPressed: () {
                                    _viewModles.updateSortState();
                                    _viewModles
                                        .updateListView(_viewModles.songList);
                                  },
                                );
                              },
                            ),
                            Text(
                              'Song List',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: _viewModles.isListView,
                          builder: (_, value, __) {
                            return MediaIconButton(
                              icon: _viewModles.isListView.value
                                  ? Icons.menu
                                  : Icons.grid_view_rounded,
                              onPressed: () {
                                _viewModles.updateListViewState();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ],
                )),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ValueListenableBuilder(
                  valueListenable: _viewModles.isListView,
                  builder: (_, value, __) {
                    return _viewModles.isListView.value
                        ? getBody(_viewModles.songList, _viewModles)
                        : getGridView(_viewModles);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getGridView(MusicAppViewModles viewModles) {
  return ListenableBuilder(
      listenable: viewModles,
      builder: (context, _) {
        return GridView.custom(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              return SongGridView(
                songList: viewModles.songList,
                song: viewModles.songList[index],
              );
            },
            childCount: viewModles.songList.length,
          ),
        );
      });
}

class SongGridView extends StatefulWidget {
  final List<Song> songList;
  final Song song;
  const SongGridView({
    super.key,
    required this.songList,
    required this.song,
  });

  @override
  State<SongGridView> createState() => _SongGridViewState();
}

class _SongGridViewState extends State<SongGridView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        child: Column(
          children: [
            Center(
              child: Leading(image: widget.song.image, height: 70, width: 100),
            ),
            SizedBox(
              height: 30,
              width: 80,
              child: Center(
                child: Text(
                  widget.song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 80,
              child: Center(
                child: Text(
                  widget.song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
        onTap: () {
          navigator(context, widget.song, widget.songList);
        },
      ),
    );
  }
}
