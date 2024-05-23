import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import '../nowplaying/now_playing.dart';

class MyListView extends StatefulWidget {
  final List<Song> songList;
  const MyListView({super.key, required this.songList});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  MusicAppViewModles viewModles = MusicAppViewModles();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModles,
      builder: (context, _) {
        return ListView.separated(
          itemCount: widget.songList.length,
          itemBuilder: (context, position) {
            return getRow(position, widget.songList, viewModles);
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
      },
    );
  }
}

Widget getRow(int a, List<Song> list, MusicAppViewModles viewModles) {
  return _SongSelection(
    viewModles: viewModles,
    song: list[a],
    list: list,
  );
}

Widget getBody(List<Song> song, MusicAppViewModles viewModles) {
  return ListenableBuilder(
      listenable: viewModles,
      builder: (context, _) {
        if (song.isNotEmpty) {
          return MyListView(songList: song);
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

void navigator(BuildContext context, Song song, List<Song> list) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return NowPlaying(
      songList: list,
      playingSong: song,
    );
  }));
}

void showBottomSheetSong(
    BuildContext context, Song song, MusicAppViewModles viewModles) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Container(
            height: 400,
            color: Colors.white,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyListTitle(
                    title: song.title,
                    onTap: () {},
                    leading: Leading(image: song.image, height: 48, width: 48),
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 24,
                    endIndent: 24,
                  ),
                  ValueListenableBuilder(
                    valueListenable: song.favorite,
                    builder: (_, value, __) {
                      return MyListTitle(
                        title: song.favorite.value == false
                            ? 'Add to Favorite Songs List'
                            : 'Added to Favorite Songs List',
                        onTap: () {
                          viewModles.updateFavoriteState(song);
                          viewModles.songToFavorite(song);
                        },
                        leading: song.favorite.value == false
                            ? const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: song.isAdded,
                    builder: (_, value, __) {
                      return MyListTitle(
                        title: song.isAdded.value == false
                            ? 'Add to NowPlaying Songs List'
                            : 'Added to NowPlaying Songs List',
                        onTap: () {
                          viewModles.updateNowPlayingListState(song);
                          viewModles.songToNowPlaying(song);
                          debugPrint(
                              viewModles.nowPlayingList.length.toString());
                        },
                        leading: song.isAdded.value == false
                            ? const Icon(
                                Icons.playlist_add_rounded,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.playlist_add_check_rounded,
                                color: Colors.red,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

class _SongSelection extends StatefulWidget {
  final Song song;
  final List<Song> list;
  final MusicAppViewModles viewModles;
  const _SongSelection(
      {required this.song, required this.list, required this.viewModles});

  @override
  State<_SongSelection> createState() => __SongSelectionState();
}

class __SongSelectionState extends State<_SongSelection> {
  @override
  Widget build(BuildContext context) {
    return MyListTitle(
      title: widget.song.title,
      leading: Leading(image: widget.song.image, height: 48, width: 48),
      subTitle: widget.song.artist,
      trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            showBottomSheetSong(context, widget.song, widget.viewModles);
          }),
      onTap: () {
        navigator(context, widget.song, widget.list);
      },
    );
  }
}

class MyListTitle extends StatelessWidget {
  final String title;
  final String? subTitle;
  final void Function()? onTap;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? titleTextStyle;
  const MyListTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.trailing,
    this.leading,
    this.titleTextStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8, top: 5),
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      onTap: onTap,
      trailing: trailing,
      leading: leading,
      titleTextStyle: titleTextStyle,
    );
  }
}

class Leading extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  const Leading(
      {super.key,
      required this.image,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/itunes.jfif',
          image: image,
          height: height,
          width: width,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/itunes.jfif',
              height: height,
              width: width,
            );
          },
        ));
  }
}

class MyPageView extends StatefulWidget {
  final MusicAppViewModles viewModles;
  final List<Song> list;
  final String image;
  final String title;
  const MyPageView(
      {super.key,
      required this.viewModles,
      required this.list,
      required this.image,
      required this.title});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  Center(
                    child: Leading(
                        image: widget.image,
                        height: screenWidth / 2.5,
                        width: screenWidth / 2.5),
                  ),
                  SizedBox(
                    height: screenWidth * 0.09,
                    width: screenWidth * 0.8,
                    child: Center(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue[200]),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 40)),
                    ),
                    onPressed: () {
                      navigator(context, widget.list[0], widget.list);
                    },
                    child: Text(
                      'Play All',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              indent: 24,
              endIndent: 24,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: getBody(widget.list, widget.viewModles),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
