import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import '../nowplaying/now_playing.dart';

class MyListView extends StatefulWidget {
  final List<Song> songList;
  const MyListView({super.key,required this.songList});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  MusicAppViewModles viewModles = MusicAppViewModles();
  MusicService musicService = MusicService();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.songList.length,
      itemBuilder: (context, position) {
        return getRow(position, widget.songList);
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

  Widget getRow(int a, List<Song> list) {
    return _SongSelection(
      song: list[a],
      parent: this,
      list: list,
    );
  }

  void navigator(Song song, List<Song> list) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songList: list,
        playingSong: song,
      );
    }));
  }
}

class _SongSelection extends StatefulWidget {
  final Song song;
  final List<Song> list;
  final _MyListViewState parent;
  const _SongSelection(
      {required this.song, required this.parent, required this.list});

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
            widget.parent.musicService.showBottomSheet(context, widget.song);
          }),
      onTap: () {
        widget.parent.navigator(widget.song, widget.list);
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
  const MyListTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.trailing,
    this.leading,
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
    );
  }
}

class Leading extends StatelessWidget {
  final String image;
  const Leading({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/itunes.jfif',
          image: image,
          height: 48,
          width: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/itunes.jfif',
              height: 48,
              width: 48,
            );
          },
        ));
  }
}
