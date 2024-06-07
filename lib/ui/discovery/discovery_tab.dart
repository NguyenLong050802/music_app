import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import 'package:music_app_flutter/ui/view_modles.dart';
import '../../data/models/song.dart';
import 'show_search.dart';
import 'package:collection/collection.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _viewModles = MusicAppViewModles();
  final List<Song> albumList = [];
  final List<Song> albumListAll = [];
  final List<Song> artistList = [];
  final List<Song> artistListAll = [];

  @override
  void initState() {
    super.initState();
    _viewModles.songList
        .groupListsBy((song) => song.album)
        .forEach((key, value) {
      albumList.add(value.first);
      albumListAll.addAll(value);
    });

    final artt = _viewModles.songList
        .where((element) => element.artist.contains('ft') == false)
        .toList();

    artt.groupListsBy((song) => song.artist).forEach((key, value) {
      artistList.add(value.first);
      artistListAll.addAll(value);
    });
    albumList.sortBy((element) => element.album);
    artistList.sortBy((element) => element.artist);
  }

  @override
  Widget build(BuildContext context) {
    final screenWith = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discovery Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: showBody(_viewModles.songList, screenWith),
    );
  }

  Widget showBody(List<Song> songList, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: ElevatedButton.icon(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: ShowSearch(
                        songList: _viewModles.songList,
                        musicAppViewModles: _viewModles));
              },
              icon: const Icon(Icons.search),
              label: const Text('Search for songs, artists,...'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).primaryColorLight),
                textStyle:
                    WidgetStateProperty.all(const TextStyle(fontSize: 26)),
                foregroundColor: WidgetStateProperty.all(Colors.black),
                iconSize: WidgetStateProperty.all(30.0),
                alignment: Alignment.centerLeft,
                minimumSize: WidgetStateProperty.all(Size(width, 50)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Albums',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GetViewAll(
                          list: albumList,
                          artistListAll: albumListAll,
                          title: 'Albums',
                          childrenDelegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return detailGrid(
                                  context,
                                  albumList,
                                  index,
                                  albumListAll,
                                  albumList[index].album,
                                  () => showGridAlbumsItem(
                                        context,
                                        albumList,
                                        index,
                                        albumListAll,
                                      ));
                            },
                            childCount: albumList.length,
                          ));
                    }));
                  },
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          getAlbumList(albumList),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Artists',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GetViewAll(
                        list: artistList,
                        artistListAll: artistListAll,
                        title: 'Artists',
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return detailGrid(
                              context,
                              artistList,
                              index,
                              artistListAll,
                              artistList[index].artist,
                              () => showGridArtItem(
                                context,
                                artistList,
                                index,
                                artistListAll,
                              ),
                            );
                          },
                          childCount: artistList.length,
                        ),
                      );
                    }));
                  },
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          getArtistList(artistList),
        ],
      ),
    );
  }

  Widget getAlbumList(List<Song> songList) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: songList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Leading(
                    image: songList[index].image,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    songList[index].album,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () => showGridAlbumsItem(
              context,
              songList,
              index,
              albumListAll,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }

  Widget getArtistList(List<Song> list) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Leading(
                    image: list[index].image,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    list[index].artist,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () => showGridArtItem(
              context,
              list,
              index,
              artistListAll,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}

class GetViewAll extends StatelessWidget {
  final List<Song> list;
  final List<Song> artistListAll;
  final String title;
  final SliverChildDelegate childrenDelegate;
  const GetViewAll({
    super.key,
    required this.list,
    required this.artistListAll,
    required this.title,
    required this.childrenDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: MediaIconButton(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        middle: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      child: GridView.custom(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 200,
        ),
        childrenDelegate: childrenDelegate,
      ),
    );
  }
}

Widget detailGrid(
  BuildContext context,
  List<Song> list,
  int index,
  List<Song> listAll,
  String title,
  void Function()? onTap,
) {
  return Material(
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Leading(
              image: list[index].image,
              height: 150,
              width: 200,
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

void showGridAlbumsItem(
  BuildContext context,
  List<Song> list,
  int index,
  List<Song> listAll,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MyPageView(
      viewModles: MusicAppViewModles(),
      list: listAll
          .where((element) => element.album == list[index].album)
          .toList(),
      image: list[index].image,
      title: list[index].album,
    );
  }));
}

void showGridArtItem(
  BuildContext context,
  List<Song> list,
  int index,
  List<Song> listAll,
) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MyPageView(
      viewModles: MusicAppViewModles(),
      list: listAll
          .where((element) => element.artist == list[index].artist)
          .toList(),
      image: list[index].image,
      title: list[index].artist,
    );
  }));
}
