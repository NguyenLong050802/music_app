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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: showBody(searctl, _viewModles.songList),
    );
  }

  Widget showBody(TextEditingController searctl, List<Song> songList) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFedf0f8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: searctl,
            decoration: const InputDecoration(
              hintText: 'What are you looking for?',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            onTap: () {
              showSearch(
                  context: context,
                  delegate: ShowSearch(
                    songList: songList,
                    musicService: _musicService,
                  ));
            },
          ),
        ),
      ],
    );
  }
}
