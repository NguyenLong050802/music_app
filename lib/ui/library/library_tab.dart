import 'package:flutter/material.dart';
import 'package:music_app_flutter/src/music_service.dart';
import 'package:music_app_flutter/ui/home/view_modles.dart';


class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  late MusicAppViewModles _viewModles;
  late MusicService _musicService;

  @override
  void initState() {
    _viewModles = MusicAppViewModles();
    _musicService = MusicService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Page'),
        centerTitle: true,
      ),
      body: _musicService.getBody(_viewModles.favoriteList, _viewModles),
    );
  }
}