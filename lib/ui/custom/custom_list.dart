import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_icon_buttom.dart';
import 'package:music_app_flutter/ui/custom/custom_textfield.dart';
import 'package:music_app_flutter/ui/view_modles.dart';
import '../../data/models/song.dart';
import '../nowplaying/now_playing.dart';

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

class MyListView extends StatefulWidget {
  final List<Song> songList;
  const MyListView({super.key, required this.songList});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.songList.length,
      itemBuilder: (context, position) {
        return getRow(position, widget.songList);
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 1,
          indent: 24,
          endIndent: 24,
          color: Theme.of(context).colorScheme.secondary,
        );
      },
      shrinkWrap: true,
    );
  }
}

Widget getRow(int a, List<Song> list) {
  return _SongSelection(
    song: list[a],
    list: list,
  );
}

Widget getProgessBar() {
  return const Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      SizedBox(
        height: 10,
      ),
      Text('Your SongList are empty...'),
    ],
  ));
}

void navigator(BuildContext context, Song song, List<Song> list) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return NowPlaying(
      songList: list,
      playingSong: song,
    );
  }));
}

void showBottomSheetSong(BuildContext context, Song song) {
  final viewModles = MusicAppViewModles();
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Container(
            height: 400,
            color: Theme.of(context).colorScheme.surface,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyListTitle(
                    title: song.title,
                    onTap: () {},
                    leading: Leading(image: song.image, height: 60, width: 60),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 24,
                    endIndent: 24,
                    color: Theme.of(context).colorScheme.secondary,
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
  const _SongSelection({required this.song, required this.list});

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
      trailing: MediaIconButton(
          icon: Icons.more_horiz,
          onPressed: () {
            showBottomSheetSong(context, widget.song);
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
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subTitle != null
          ? Text(subTitle!, style: Theme.of(context).textTheme.bodyLarge)
          : null,
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
  final List<Song> list;
  final MusicAppViewModles viewModles;
  final String image;
  final String title;
  const MyPageView(
      {super.key,
      required this.list,
      required this.viewModles,
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
      appBar: AppBar(
        leading: MediaIconButton(
          icon: Icons.arrow_back,
          size: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.62,
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
                  MyTextButton(
                    title: 'Play All',
                    onPressed: () {
                      navigator(context, widget.list[0], widget.list);
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 24,
              endIndent: 24,
              color: Theme.of(context).colorScheme.secondary,
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
