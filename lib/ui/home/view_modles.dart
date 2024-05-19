import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:music_app_flutter/data/repository/repository.dart';
import 'package:music_app_flutter/src/firebase_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/song.dart';

class MusicAppViewModles extends ChangeNotifier {
  final firebaseService = FireBaseService();
  final List<Song> songList = [];
  final List<Song> favoriteList = [];
  final List<Song> nowPlayingList = [];

  static final _musicViewModel = MusicAppViewModles._internal();
  factory MusicAppViewModles() => _musicViewModel;
  MusicAppViewModles._internal() {
    firebaseService.loadSongFromFb('song').then((value) {
      if (value is List<Song>) {
        songList.clear();
        songList.addAll(value);
        notifyListeners();
      }
    });
    firebaseService.loadSongFromFb('favoriteSong').then((value) {
      if (value is List<Song>) {
        favoriteList.clear();
        favoriteList.addAll(value);
        notifyListeners();
      }
    });

    firebaseService.loadSongFromFb('nowPlaying').then((value) {
      if (value is List<Song>) {
        nowPlayingList.clear();
        nowPlayingList.addAll(value);
        notifyListeners();
      }
    });
  }

  // StreamController<List<Song>> songStream = StreamController();
  // void loadSong() {
  //   final data = DefaultRepositort();
  //   data.loadData().then((value) {
  //     songStream.add(value!);
  //   });
  // }

  Future addFavotiteSong(Song song, List<Song> list, String collection) async {
    list.add(song);
    notifyListeners();
    await firebaseService.addSongToFb(song, collection);
  }

  Future deleteSongsNotFavorite(
      Song song, List<Song> list, String collection) async {
    list.removeWhere((element) => element.id == song.id);
    notifyListeners();
    await firebaseService.removeSongFromFb(song, collection);
  }

  Future updateFavoriteSongValue(Song song, String collection) async {
    notifyListeners();
    await firebaseService.updateSongToFb(song, collection);
  }

  Future updateAddedSongValue(Song song, String collection) async {
    notifyListeners();
    await firebaseService.updateAddedSongToFb(song, collection);
  }

  void updateFavoriteState(Song song) {
    song.favorite.value = !song.favorite.value;
    notifyListeners();
  }

  void updateNowPlayingListState(Song song) {
    song.isAdded.value = !song.isAdded.value;
    notifyListeners();
  }

  Future shareSong(Song song) async {
    await Share.share('This is a great song! ${song.source}');
  }

  Future songToFavorite(Song song) async {
    if (song.favorite.value == true) {
      addFavotiteSong(song, favoriteList, 'favoriteSong');
      await updateFavoriteSongValue(song, 'song');
      for (var a in nowPlayingList) {
        if (a.id == song.id) {
          await updateFavoriteSongValue(song, 'nowPlaying');
        }
      }
    } else {
      deleteSongsNotFavorite(song, favoriteList, 'favoriteSong');
      await updateFavoriteSongValue(song, 'song');
      for (var a in nowPlayingList) {
        if (a.id == song.id) {
          await updateFavoriteSongValue(song, 'nowPlaying');
        }
      }
    }
  }

  Future songToNowPlaying(Song song) async {
    if (song.isAdded.value == true) {
      addFavotiteSong(song, nowPlayingList, 'nowPlaying');
      await updateAddedSongValue(song, 'song');
      for (var a in favoriteList) {
        if (a.id == song.id) {
          await updateAddedSongValue(song, 'favoriteSong');
        }
      }
    } else {
      deleteSongsNotFavorite(song, nowPlayingList, 'nowPlaying');
      await updateAddedSongValue(song, 'song');
      for (var a in favoriteList) {
        if (a.id == song.id) {
          await updateAddedSongValue(song, 'favoriteSong');
        }
      }
    }
  }
}
