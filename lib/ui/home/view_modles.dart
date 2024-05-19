import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/data/repository/repository.dart';
import 'package:music_app_flutter/src/firebase_service.dart';

import '../../data/models/song.dart';

class MusicAppViewModles extends ChangeNotifier {
  final firebaseService = FireBaseService();
  final List<Song> favoriteList = [];

  static final _musicViewModel = MusicAppViewModles._internal();
  factory MusicAppViewModles() => _musicViewModel;
  MusicAppViewModles._internal() {
    firebaseService.loadFavoriteSongFromFb().then((value) {
      if (value is List<Song>) {
        favoriteList.clear();
        favoriteList.addAll(value);
        notifyListeners();
      }
    });
  }

  StreamController<List<Song>> songStream = StreamController();
  void loadSong() {
    final data = DefaultRepositort();
    data.loadData().then((value) {
      songStream.add(value!);
    });
  }

  Future addFavotiteSong(Song song) async {
    favoriteList.add(song);
    notifyListeners();
    await firebaseService.addFavoriteSongToFb(song);
  }

  Future deleteSongsNotFavorite(Song song) async {
    favoriteList.remove(song);
    notifyListeners();
    await firebaseService.removeFavoriteSongFromFb(song);
  }

  Future updateFavoriteSongValue(Song song, String favorite) async {
    notifyListeners();
    await firebaseService.updateSongToFb(song, favorite);
  }

}
