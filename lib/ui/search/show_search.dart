import 'package:flutter/material.dart';
import 'package:music_app_flutter/data/models/song.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import '../nowplaying/now_playing.dart';

class ShowSearch extends SearchDelegate {
  final List<Song> songList;
  final MusicService musicService;
  ShowSearch({required this.songList, required this.musicService});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResult = songList
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.separated(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        return MyListTitle(
          title: searchResult[index].title,
          subTitle: searchResult[index].artist,
          leading: Leading(
            image: searchResult[index].image,
            height: 48,
            width: 48,
          ),
          trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                musicService.showBottomSheet(context, searchResult[index]);
              }),
          onTap: () {
            close(context, searchResult[index]);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NowPlaying(
                  songList: songList,
                  playingSong: searchResult[index],
                ),
              ),
            );
          },
        );
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResult = songList
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.separated(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        return MyListTitle(
          title: searchResult[index].title,
          subTitle: searchResult[index].artist,
          leading: Leading(
            image: searchResult[index].image,
            height: 48,
            width: 48,
          ),
          trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                musicService.showBottomSheet(context, searchResult[index]);
              }),
          onTap: () {
            close(context, searchResult[index]);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NowPlaying(
                  songList: songList,
                  playingSong: searchResult[index],
                ),
              ),
            );
          },
        );
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

}

