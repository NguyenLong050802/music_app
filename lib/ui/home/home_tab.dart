import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import '../custom/custom_list.dart';
import '../library/library_tab.dart';
import '../search/search_tab.dart';
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
  // late MusicAppViewModles _viewModles;
  // @override
  // void initState() {
  //   super.initState();
  //   _viewModles = MusicAppViewModles();
  // }

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

  @override
  void initState() {
    super.initState();
    _viewModles = MusicAppViewModles();
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
      body: Column(
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
    );
  }

  // @override
  // void dispose() {
  //   _viewModles.songStream.close();
  //   super.dispose();
  // }
}

Widget getGridView(MusicAppViewModles viewModles) {
  return GridView.custom(
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    childrenDelegate: SliverChildBuilderDelegate(
      (context, index) {
        return SongGridView(
          viewModles: viewModles,
          songList: viewModles.songList,
          song: viewModles.songList[index],
        );
      },
      childCount: viewModles.songList.length,
    ),
  );
}

class SongGridView extends StatefulWidget {
  final MusicAppViewModles viewModles;
  final List<Song> songList;
  final Song song;
  const SongGridView({
    super.key,
    required this.viewModles,
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
