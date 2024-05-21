import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import '../../src/music_service.dart';
import 'show_search.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final searctl = TextEditingController();
  final _viewModles = MusicAppViewModles();
  final _musicService = MusicService();
  @override
  Widget build(BuildContext context) {
    final screenWith = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: showBody(searctl, _viewModles.songList, screenWith),
    );
  }

  Widget showBody(
      TextEditingController searctl, List<Song> songList, double width) {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton.icon(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ShowSearch(
                      songList: _viewModles.songList,
                      musicService: _musicService));
            },
            icon: const Icon(Icons.search),
            label: const Text('What are you looking for?'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
              textStyle:
                  MaterialStateProperty.all(const TextStyle(fontSize: 26.0)),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              iconSize: MaterialStateProperty.all(30.0),
              alignment: Alignment.centerLeft,
              minimumSize: MaterialStateProperty.all(
                Size(width, 50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
