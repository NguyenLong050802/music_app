import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';
import '../../data/models/song.dart';
import 'show_search.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _viewModles = MusicAppViewModles();
  @override
  Widget build(BuildContext context) {
    final screenWith = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: showBody(_viewModles.songList, screenWith),
    );
  }

  Widget showBody(List<Song> songList, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
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
        ],
      ),
    );
  }
}
